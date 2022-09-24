import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:webview_flutter/webview_flutter.dart';

class GitHubSignIn {
  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  final String scope;
  final String? initialLogin;
  final String title;
  final bool? centerTitle;
  final bool allowSignUp;
  final bool clearCache;

  final String _githubAuthorizedUrl =
      "https://github.com/login/oauth/authorize";
  final String _githubAccessTokenUrl =
      "https://github.com/login/oauth/access_token";

  GitHubSignIn({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    this.initialLogin,
    this.scope = "user,gist,user:email",
    this.title = "",
    this.centerTitle,
    this.allowSignUp = true,
    this.clearCache = true,
  });

  Future<GitHubSignInResult> signIn(BuildContext context) async {
    // let's authorize
    var authorizedResult;

    authorizedResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GitHubSignInPage(
          url: _generateAuthorizedUrl(),
          redirectUrl: redirectUrl,
          clearCache: clearCache,
          title: title,
          centerTitle: centerTitle,
        ),
      ),
    );

    if (authorizedResult == null ||
        authorizedResult.toString().contains('access_denied')) {
      return GitHubSignInResult(
        GitHubSignInResultStatus.cancelled,
        errorMessage: "Sign In attempt has been cancelled.",
      );
    } else if (authorizedResult is Exception) {
      return GitHubSignInResult(
        GitHubSignInResultStatus.failed,
        errorMessage: authorizedResult.toString(),
      );
    }

    // exchange for access token
    String code = authorizedResult;
    var response = await http.post(
      Uri.parse(_githubAccessTokenUrl),
      headers: {"Accept": "application/json"},
      body: {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": code
      },
    );
    GitHubSignInResult result;
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      result = GitHubSignInResult(
        GitHubSignInResultStatus.ok,
        token: body["access_token"],
      );
    } else {
      result = GitHubSignInResult(
        GitHubSignInResultStatus.cancelled,
        errorMessage:
            "Unable to obtain token. Received: ${response.statusCode}",
      );
    }

    return result;
  }

  String _generateAuthorizedUrl() {
    String url = "$_githubAuthorizedUrl?" +
        "client_id=$clientId" +
        "&redirect_uri=$redirectUrl" +
        "&scope=$scope" +
        "&allow_signup=$allowSignUp";
    if(initialLogin != null) url += '&login=$initialLogin';
    return url;
  }
}

class GitHubSignInPage extends StatelessWidget {
  final String url;
  final String redirectUrl;
  final bool clearCache;
  final String title;
  final bool? centerTitle;
  final String? userAgent;

  const GitHubSignInPage(
      {Key? key,
      required this.url,
      required this.redirectUrl,
      this.userAgent,
      this.clearCache = true,
      this.title = "",
      this.centerTitle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (url) {
            if (url.contains("error=")) {
              Navigator.of(context).pop(
                Exception(Uri.parse(url).queryParameters["error"]),
              );
            } else if (url.startsWith(redirectUrl)) {
              Navigator.of(context).pop(
                  url.replaceFirst("${redirectUrl}?code=", "").trim());
            }
          },
        ));
  }
}

class GitHubSignInResult {
  final String? token;
  final GitHubSignInResultStatus status;
  final String errorMessage;

  GitHubSignInResult(
    this.status, {
    this.token,
    this.errorMessage = "",
  });
}

enum GitHubSignInResultStatus {
  /// The login was successful.
  ok,

  /// The user cancelled the login flow, usually by closing the
  /// login dialog.
  cancelled,

  /// The login completed with an error and the user couldn't log
  /// in for some reason.
  failed,
}

import 'package:cs_mobile/top_level_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:github_sign_in/github_sign_in.dart';
import 'package:cs_mobile/auth/auth_service.dart';



class AuthModel {
  Future<void> authenticate(context, ref, String? initialLogin) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      scope: 'public_repo, user, notifications',
      clientId: '4b4d462397a576ac86fd',
      clientSecret: '7bbde3c03020db1b1f31f6080e6823cc415086cd',
      redirectUrl: 'https://crowd-solve.firebaseapp.com/__/auth/handler',
      initialLogin: initialLogin);
    try {
      //Show the sign in webview and get the token from it
      final GitHubSignInResult signInResult = await gitHubSignIn.signIn(context);

      //Check if sign in was successfull
      if (signInResult.status.name != "ok") throw Exception(signInResult.errorMessage);

      ref.watch(githubOAuthKeyModelProvider.notifier).setGithubOAuthKey(signInResult.token);

      
      //Login to google with the github credentials
      await FirebaseAuth.instance
          .signInWithCredential(GithubAuthProvider.credential(signInResult.token!));

    } catch (e) {
      rethrow;
    }
  }
}

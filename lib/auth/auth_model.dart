import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

class AuthModel with ChangeNotifier {
  final FirebaseAuth firebaseAuth;
  bool isLoading;
  bool submitted;

  AuthModel({
    required this.firebaseAuth,
    this.isLoading = false,
    this.submitted = false,
  });
  Future<bool> authenticate(context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      scope: 'public_repo, user',
      clientId: '4b4d462397a576ac86fd',
      clientSecret: '7bbde3c03020db1b1f31f6080e6823cc415086cd',
      redirectUrl: 'https://crowd-solve.firebaseapp.com/__/auth/handler');

    
    try {
      final result = await gitHubSignIn.signIn(context);
      final githubAuthCredential = GithubAuthProvider.credential(result.token!);
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(githubAuthCredential);
      updateWith(isLoading: true);

      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateWith({
    bool? isLoading,
    bool? submitted,
  }) {
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}

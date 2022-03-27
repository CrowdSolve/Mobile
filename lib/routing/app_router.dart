import 'package:cs_mobile/auth/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const githubAuthPage = '/github-auth-page';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.githubAuthPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => GithubAuthScreen.withFirebaseAuth(
            firebaseAuth,
            onSignedIn: args as void Function(),
          ),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}

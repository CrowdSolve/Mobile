import 'package:cs_mobile/top_level_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  Future<void> authenticate(context, ref,
      {String? initialLogin, required bool allowSignUp}) async {
    Future<UserCredential> signInWithGitHub() async {
      GithubAuthProvider githubProvider = GithubAuthProvider();
      githubProvider.addScope('public_repo');
      githubProvider.addScope('user');
      githubProvider.addScope('notifications');
      githubProvider.setCustomParameters({
        'allow_signup': '$allowSignUp',
        'login': '$initialLogin',
      });

      return await FirebaseAuth.instance.signInWithProvider(githubProvider);
    }

    UserCredential signInResult = await signInWithGitHub();

    ref
        .watch(githubOAuthKeyModelProvider.notifier)
        .setGithubOAuthKey(signInResult.credential!.accessToken!);
  }
}

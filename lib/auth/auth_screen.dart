import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:cs_mobile/auth/auth_model.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GithubAuthScreen extends ConsumerStatefulWidget {
  final AuthModel model;
  final VoidCallback? onSignedIn;
  const GithubAuthScreen({
    Key? key,
    this.onSignedIn,
    required this.model,
  }) : super(key: key);

  factory GithubAuthScreen.withFirebaseAuth(FirebaseAuth firebaseAuth,
      {VoidCallback? onSignedIn}) {
    return GithubAuthScreen(
      model: AuthModel(firebaseAuth: firebaseAuth),
      onSignedIn: onSignedIn,
    );
  }

  @override
  _GithubAuthScreenState createState() => _GithubAuthScreenState();
}

class _GithubAuthScreenState extends ConsumerState<GithubAuthScreen> {
   AuthModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    // Temporary workaround to update state until a replacement for ChangeNotifierProvider is found
    model.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox(
          width: 200,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.github, color: Colors.white,),
                SizedBox(width: 20,),
                Text("Sign in with Github", style: TextStyle(color: Colors.white),)
              ],
            ),
            onPressed: model.isLoading ? null : _submit,
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider.notifier);

    try {
      final String githubOAuthKey = await model.authenticate(context);
      githubOAuthKeyModel.setGithubOAuthKey(githubOAuthKey);
      if (widget.onSignedIn != null) {
        widget.onSignedIn?.call();
      }
    } catch (e) {
      _showSignInError(model, e);
    }
  }


  void _showSignInError(AuthModel model, dynamic exception) {
    showExceptionAlertDialog(
      context: context,
      title: "Failed",
      exception: exception,
    );
  }

}


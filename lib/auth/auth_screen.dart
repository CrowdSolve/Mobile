import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/auth/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GithubAuthScreen extends StatefulWidget {
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
  State<GithubAuthScreen> createState() => _GithubAuthScreenState();
}

class _GithubAuthScreenState extends State<GithubAuthScreen> {
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
    return Center(
      child: ElevatedButton(
        child: Text("asas"),
        onPressed: model.isLoading ? null : _submit,
      ),
    );
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.authenticate(context);
      if (success) {
        if (widget.onSignedIn != null) {
          widget.onSignedIn?.call();
        }
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


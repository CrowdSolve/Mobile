import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:cs_mobile/auth/auth_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GithubAuthScreen extends ConsumerStatefulWidget {

  @override
  _GithubAuthScreenState createState() => _GithubAuthScreenState();
}

class _GithubAuthScreenState extends ConsumerState<GithubAuthScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.3,0.9,1
                ],
                colors: [
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.onSecondary,
                  Theme.of(context).colorScheme.onTertiary,
                ],
              ),
            ),
            child: Center(
        child: SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            child: _isLoading?CircularProgressIndicator(): Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.github,),
                SizedBox(width: 20,),
                Text("Sign in with Github",)
              ],
            ),
            onPressed: _isLoading
                  ? null
                  : () {
                      _submit();
                      setState(() {
                        _isLoading = true;
                      });
                    }),
        ),
      ),
    ),
    );
  }

  Future<void> _submit() async {
    try {
      await AuthModel().authenticate(context, ref);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSignInError(e);
    }
  }


  void _showSignInError(Object exception) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'More info',
          textColor: Theme.of(context).colorScheme.onErrorContainer,
          onPressed: () {
            showExceptionAlertDialog(
              context: context,
              title: 'Sign in failed',
              exception: exception,
            );
          },
        ),
        content: Text(
          'Sign in failed',
          style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
    );
  }

}


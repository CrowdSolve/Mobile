import 'package:cs_mobile/auth/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthButton extends ConsumerStatefulWidget {
  @override
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends ConsumerState<AuthButton> {
  bool _isLoading = false;
    TextEditingController controller= TextEditingController();
  Future<void> _submit() async {
    String login  = controller.text;

    if(login.isEmpty || login.length > 39 || login.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please enter a valid username or an email',
          style:
              TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
        ),
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ));
      return;
    };
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthModel().authenticate(context, ref, initialLogin: login, allowSignUp: false);
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
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Login failed'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    const Radius radius = Radius.circular(40);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.all(radius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              onSubmitted: (_) => _submit(),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.go,
              controller: controller,
              decoration: InputDecoration(
                  hintText: 'Username or email',
                  prefixIcon: Icon(
                    FontAwesomeIcons.github,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  border: InputBorder.none),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              child: 
              _isLoading? CircularProgressIndicator(): Text(
                'Login',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              onPressed: !_isLoading? _submit:null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                padding: EdgeInsets.zero,
                maximumSize: Size.infinite,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: Size.infinite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: radius,
                      bottomRight: radius,
                      bottomLeft: radius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/auth_button.dart';

class GithubAuthScreen extends ConsumerStatefulWidget {

  @override
  _GithubAuthScreenState createState() => _GithubAuthScreenState();
}

class _GithubAuthScreenState extends ConsumerState<GithubAuthScreen> {
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
          width: 300,
          height: 50,
          child: AuthButton()
        ),
      ),
    ),
    );
  } 
}
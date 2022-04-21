import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/screens/main_screen/my_questions/my_questions.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDialog extends ConsumerWidget  {
  final UserModel user;
  const ProfileDialog({Key? key, required this.user}) : super(key: key);
  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      Navigator.pop(context);
      await firebaseAuth.signOut();
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: "Logout failed",
        exception: e,
      ));
    }
  }
  Future<void> _confirmSignOut(
      BuildContext context, FirebaseAuth firebaseAuth) async {
    final bool didRequestSignOut = await showAlertDialog(
          context: context,
          title: "Logout",
          content: "Are you sure",
          cancelActionText: "Cancel",
          defaultActionText: "Logout",
        ) ??
        false;
    if (didRequestSignOut == true) {
      await _signOut(context, firebaseAuth);
    }
  }
  @override
  Widget build(BuildContext context, ref) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return SafeArea(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close_rounded)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Text(
                              user.login,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              user.id.toString(),
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 22,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        child: Text('My Questions'),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyQuestions(user.login)),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          tooltip: "Sign out",
                          onPressed: () =>
                              _confirmSignOut(context, firebaseAuth),
                          icon: Icon(Icons.logout_rounded),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'avatar',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(user.avatarUrl),
                  maxRadius: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

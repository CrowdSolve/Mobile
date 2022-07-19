import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/screens/main_screen/my_notifications/my_notifications.dart';
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
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);
    return SafeArea(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        elevation: 10,
        insetPadding: EdgeInsets.only(top: 75, right: 15, left: 15),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close_rounded)),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'avatar',
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(user.avatarUrl),
                      ),
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    user.name==""?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Youssef Lasheen',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal,),
                        ),
                        Text(
                          user.login,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                      ],
                    ):Text(
                          user.login,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                    
                    
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),
              ListTile(
                leading: Icon(Icons.my_library_books),
                title: Text('My questions'),
                onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyQuestions(user.login)),
                ),
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('My Notifications'),
                onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyNotifications(githubOAuthKeyModel)),
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
    );
  }
}

import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'screens/my_answers/my_answers.dart';
import 'screens/my_notifications/my_notifications.dart';
import 'screens/my_questions/my_questions.dart';

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
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: 1000,
            width: double.infinity,
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
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(user.avatarUrl),
                          ),
                          SizedBox(
                            width: 22,
                          ),
                          user.name!=""?
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    user.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.normal,),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    user.login,
                                      overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ):Flexible(
                            child: Text(
                                  user.login,
                                  overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.normal),
                                ),
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
                    ListTile(
                      leading: Icon(Icons.question_answer_rounded),
                      title: Text('My Answers'),
                      onTap: ()=> Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyAnswers(githubOAuthKeyModel)),
                      ),
                    ),
                    Divider(),
                    ListTile(
                        leading: Icon(Icons.privacy_tip_rounded),
                        title: Text('Privacy Policy'),
                        onTap: () => launchUrl(Uri.parse(
                            'https://raw.githubusercontent.com/CrowdSolve/privacy-policy/main/README.md'))),
                    ListTile(
                      leading: Icon(Icons.gavel_rounded),
                      title: Text('Open Source Licenses'),
                      //TODO: Check for version and add it
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: 'CrowdSolve',
                        applicationLegalese: '© 2022 Lasheen LLC',
                        applicationIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/icon.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline_rounded),
                      title: Text('Help & Feedback'),
                      onTap: ()=> launchUrl(Uri.parse(
                            'https://github.com/CrowdSolve/Mobile/discussions')),
                    ),
                    Spacer(),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(),
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () => _confirmSignOut(context, firebaseAuth),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

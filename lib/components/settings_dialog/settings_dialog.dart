import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'screens/my_answers/my_answers.dart';
import 'screens/my_notifications/my_notifications.dart';
import 'screens/my_questions/my_questions.dart';

class ProfileDialog extends ConsumerWidget  {
  final FullUserModel user;
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
    final themeMode = ref.watch(themeModeProvider);
    final double height = MediaQuery. of(context). size. height - MediaQuery.of(context).viewPadding.top;
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: height + 1,
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
                    Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.close_rounded)),
                        ),
                        Expanded(
                          child: Image.asset(
                              'assets/LLLogo.png',
                              height: 25,
                              width: 25,
                            ),
                        ),
                        Spacer()
                      ],
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: () => context.go('/users/s', extra: UserModel(login: user.login, avatarUrl: user.avatarUrl, id: user.id,)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: SizedBox(
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
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
                      leading: Icon(Icons.color_lens),
                      title: Text('Theme'),
                      subtitle: Text(themeMode?'Dark':'Light', style: TextStyle(fontSize: 12),),
                      onTap: ()=> showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Theme'),
                          content: Text('Do you want to switch to the ${themeMode?'Light':'Dark'} theme?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(themeModeProvider.notifier).toggle();
                                Navigator.of(context).pop();
                              },
                              child: Text('Toggle Theme'),
                            ),
                          ],
                        ),
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
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red,),
                      title: Text('Logout', style: TextStyle(color: Colors.red),),
                      onTap: () => _confirmSignOut(context, firebaseAuth),
                    ),
                    Spacer(),
                    //TODO: Add current version
                    Center(child: Text('CrowdSolve Mobile v1.0.0',style: Theme.of(context).textTheme.caption),)
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

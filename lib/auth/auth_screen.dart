import 'package:cs_mobile/auth/auth_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/auth_button.dart';

class GithubAuthScreen extends ConsumerStatefulWidget {
  @override
  _GithubAuthScreenState createState() => _GithubAuthScreenState();
}

class _GithubAuthScreenState extends ConsumerState<GithubAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.3, 0.9, 1],
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
            Theme.of(context).colorScheme.tertiaryContainer,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/login_anim.gif',
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to ',
                          style: GoogleFonts.lato(
                            textStyle:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                          ),
                        ),
                        TextSpan(
                          text: '\nCrowdSolve',
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                )
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextSpan(
                          text:
                              '\n\nA platform to make sharing information easier. \nIt is build on the source-control open source principles and is even powered by github.',
                          style: GoogleFonts.lato(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                )
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Center(
                    child: SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('LOGIN WITH GITHUB',
                                style: GoogleFonts.abel(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(height: 50, child: AuthButton()),
                          SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style: GoogleFonts.roboto(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign up',
                                  style: GoogleFonts.roboto(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        )
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      try {
                                        await AuthModel().authenticate(
                                            context, ref,
                                            allowSignUp: true);
                                      } catch (e) {}
                                    },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.roboto(
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer),
                          ),
                          children: [
                            TextSpan(
                              text: 'By logging in, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                  launchUrl(
                                    Uri.parse(
                                        'https://raw.githubusercontent.com/CrowdSolve/privacy-policy/main/README.md'),
                                
                                
                            ),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

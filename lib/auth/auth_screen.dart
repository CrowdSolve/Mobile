import 'package:auto_size_text/auto_size_text.dart';
import 'package:cs_mobile/auth/auth_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
                  Flexible(
                    flex: 6,
                    child: Center(
                      child: Image.asset(
                        'assets/login_anim.gif',
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: AutoSizeText.rich(
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
                                   fontWeight: FontWeight.w500
                                  )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  
                  Flexible(
                    flex: 4,
                    child: Center(
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
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                
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
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an account? ',
                                    
                                  ),
                                  TextSpan(
                                    text: 'Sign up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        try {
                                          await AuthModel().authenticate(
                                              context, ref,
                                              allowSignUp: true);
                                        } catch (e) {}
                                      },
                                  ),
                                  TextSpan(
                                    text: '\nor continue as a guest',
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
                                        context.go('/');
                                      },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Spacer(),
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

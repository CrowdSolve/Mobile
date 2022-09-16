import 'package:cs_mobile/screens/main_screen/main_screen.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_details/question_details.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_screen.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangesProvider);
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return authStateChanges.when(
      data: (user) {
        bool isSignedIn = user != null;
        late final _router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => MainScreen(),
              routes: [
                GoRoute(
                  path: 'questions/:id',
                  builder: (context, state) => QuestionDetails(id: state.params['id']!,),
                ),
              ],
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) =>
                  GithubAuthScreen.withFirebaseAuth(firebaseAuth),
            ),
          ],
          redirect: (state) {
            final loggingIn = state.subloc == '/login';
            if (!isSignedIn) return loggingIn ? null : '/login';

            if (loggingIn) return '/';

            return null;
          },
        );
        return DynamicColorBuilder(builder: (ightDynamic, darkDynamic) {
          ColorScheme darkColorScheme;

          if (darkDynamic != null) {
            darkColorScheme = darkDynamic.harmonized();
          } else {
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            );
          }
          return MaterialApp.router(
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
            ),
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
          );
        });
      },
      loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      error: (object, stackTrace) => Center(child: Text(object.toString()),)
    );
  }
}

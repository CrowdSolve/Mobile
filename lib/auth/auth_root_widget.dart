import 'package:cs_mobile/components/profile_screen/profile_screen.dart';
import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/screens/questions_screen/main_screen.dart';
import 'package:cs_mobile/screens/questions_screen/shared_components/question_details/question_details.dart';
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
    final themeMode = ref.watch(themeModeProvider);
    return authStateChanges.when(
      data: (user) {
        bool isSignedIn = user != null;
        late final _router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => QuestionsScreen(),
              routes: [
                GoRoute(
                  path: 'questions/:id',
                  builder: (context, state) => state.extra != null? QuestionDetails(id: state.params['id']!, question: state.extra! as Question,):QuestionDetails(id: state.params['id']!),
                ),
                GoRoute(
                  path: 'users/:id',
                  builder: (context, state) => state.extra != null? ProfileScreen( user: state.extra! as UserModel,):ProfileScreen(userId: state.params['id']!),),
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
        return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
          ColorScheme darkColorScheme;
          ColorScheme lightColorScheme;


          if (darkDynamic != null) {
            darkColorScheme = darkDynamic.harmonized();
          } else {
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            );
          }

          if (lightDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
          } else {
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            );
          }
          return MaterialApp.router(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme,
            ),
            debugShowCheckedModeBanner: false,
            themeMode: themeMode? ThemeMode.dark: ThemeMode.light,
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

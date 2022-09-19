import 'package:cs_mobile/services/shared_prefrences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());



final githubOAuthKeyModelProvider =
    StateNotifierProvider<GithubOAuthKeyModel, String>((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return GithubOAuthKeyModel(sharedPreferencesService);
});

class GithubOAuthKeyModel extends StateNotifier<String> {
  GithubOAuthKeyModel(this.sharedPreferencesService)
      : super(sharedPreferencesService.getGithubOAuthKey()??'');
  final SharedPreferencesService sharedPreferencesService;

  Future<void> setGithubOAuthKey(key) async {
    await sharedPreferencesService.setGithubOAuthKey(key);
    state = key;
  }
  String get getGithubOAuthKey => state;
}


class ThemeModeNotifier extends StateNotifier<bool> {
  late SharedPreferences prefs;

  Future _init() async {
    prefs = await SharedPreferences.getInstance();
    var themeMode = prefs.getBool("themeMode");
    state = themeMode ?? true;
  }

  ThemeModeNotifier() : super(false) {
    _init();
  }

  void toggle() async {
    state = !state;
    prefs.setBool("themeMode", state);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>(
  (ref) => ThemeModeNotifier(),
);
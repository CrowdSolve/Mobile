import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const githubOAuthKey = 'githubOAuthKey';

  Future<void> setGithubOAuthKey(key) async {
    await sharedPreferences.setString(githubOAuthKey, key);
  }

  String? getGithubOAuthKey() =>
      sharedPreferences.getString(githubOAuthKey);
}
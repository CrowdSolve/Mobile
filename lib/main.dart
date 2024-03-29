import 'package:cs_mobile/auth/auth_root_widget.dart';
import 'package:cs_mobile/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/shared_prefrences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  await initHiveForFlutter();
  if (kReleaseMode)
    await InAppUpdate.checkForUpdate().then((info) {
      if (info.immediateUpdateAllowed)
        InAppUpdate.performImmediateUpdate().then((result) {
          if (result != AppUpdateResult.success) SystemNavigator.pop();
        });
    });
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesServiceProvider.overrideWithValue(
        SharedPreferencesService(sharedPreferences),
      ),
    ],
    child: AuthWidget(),
  ));
}
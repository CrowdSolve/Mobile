
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cs_mobile/screens/main_screen/models/notification.dart';

Future<List<NotificationModel>> fetchNotifications(String authKey, int pageKey) async {
  final response = await http.get(
    Uri.parse('https://api.github.com/repos/CrowdSolve/data/notifications?all=true&page=$pageKey'),
    headers: <String, String>{
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer ' + authKey,
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var tagObjsJson = jsonDecode(response.body) as List;
    List<NotificationModel> tagObjs =
        tagObjsJson.map((tagJson) => NotificationModel.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

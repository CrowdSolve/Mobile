
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cs_mobile/models/answer.dart';


Future<List<Answer>> fetchAnswers(String authKey, int pageKey) async {
  final response = await http.get(
    Uri.parse('https://api.github.com/repos/CrowdSolve/data/notifications?page=$pageKey&?reason=comment'),
    headers: <String, String>{
      'Accept': 'application/vnd.github+json',
      'Authorization': 'Bearer ' + authKey,
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var tagObjsJson = jsonDecode(response.body) as List;
    List<Answer> tagObjs =
        tagObjsJson.map((tagJson) => Answer.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

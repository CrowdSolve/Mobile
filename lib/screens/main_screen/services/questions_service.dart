import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/question.dart';


Future<List<Question>> fetch(int pageKey) async {
  final response = await http.get(Uri.parse(
      'https://api.github.com/repos/CrowdSolve/data/issues?page=$pageKey'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var tagObjsJson = jsonDecode(response.body) as List;
    List<Question> tagObjs =
        tagObjsJson.map((tagJson) => Question.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Question>> fetchWithQuery(int pageKey,
    {required String searchTerm}) async {
      print(searchTerm);
  final response = await http.get(Uri.parse(
      'https://api.github.com/search/issues?q=repo:CrowdSolve/data+$searchTerm'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.statusCode);
    var tagObjsJson = jsonDecode(response.body)['items'] as List;
    List<Question> tagObjs =
        tagObjsJson.map((tagJson) => Question.fromJson(tagJson)).toList();

    print(tagObjs);
    return tagObjs;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

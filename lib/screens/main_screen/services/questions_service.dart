import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/question.dart';


Future<Questions> fetch() async {
  final response = await http.get(Uri.parse(
      'https://api.github.com/repos/CrowdSolve/data/issues?page=1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Questions.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
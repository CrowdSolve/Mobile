import 'dart:convert';

import 'package:cs_mobile/models/user.dart';

import 'package:http/http.dart' as http;

Future<FullUserModel> fetchAuthenticatedUser(authKey) async {
  final response = await http.get(
    Uri.parse('https://api.github.com/user'),
    headers: <String, String>{
      'Authorization': 'token ' + authKey,
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return FullUserModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<FullUserModel> fetchUserWithId(id) async {
  final response = await http.get(
    Uri.parse('https://api.github.com/users/$id'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return FullUserModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
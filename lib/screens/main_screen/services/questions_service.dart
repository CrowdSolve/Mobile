import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/comment.dart';
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
      'https://api.github.com/search/issues?q=repo:CrowdSolve/data+$searchTerm&page=$pageKey'));

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

Future<Question> fetchWithId(int id) async {
  final response = await http.get(Uri.parse(
      'https://api.github.com/repos/CrowdSolve/data/issues/$id'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return Question.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to load album');
  }
}

Future<List<Comment>> fetchCommentsWithIssueId(int id, int pageKey) async {
  final response = await http.get(Uri.parse(
      'https://api.github.com/repos/CrowdSolve/data/issues/$id/comments?page=$pageKey'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var tagObjsJson = jsonDecode(response.body) as List;
    List<Comment> tagObjs =
        tagObjsJson.map((tagJson) => Comment.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to load album');
  }
}

Future<bool> likeQuestion(String authKey, int questionId) async {
  print('attempt like');
  final response = await http.post(
    Uri.parse(
        'https://api.github.com/repos/CrowdSolve/data/issues/$questionId/reactions'),
    headers: <String, String>{
      'Authorization': 'token ' + authKey,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'content': 'heart'}),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 200/201 OK/CREATED response,
    // then return true.
    return true;
  } else {
    // If the server did not return a 201 CREATED response,
    // then return false.
    print(response.statusCode);
    return false;
  }
}

Future<bool> unlikeQuestion(String authKey, int questionId, int userId) async {
  final reactionsResponse = await http.get(
    Uri.parse(
        'https://api.github.com/repos/CrowdSolve/data/issues/$questionId/reactions'),
  );

  if (reactionsResponse.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then return true.
    for (final reaction in jsonDecode(reactionsResponse.body)) {
      if (reaction['user']['id'] == userId || reaction['content'] == 'heart') {
        final response = await http.delete(
          Uri.parse(
              'https://api.github.com/repos/CrowdSolve/data/issues/$questionId/reactions/${reaction['id']}'),
          headers: <String, String>{
            'Authorization': 'token ' + authKey,
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        if (response.statusCode == 204) {
          // If the server did return a 204 response,
          // then return false.
          return false;
        }
        break;
      }
    }
  }
  return true;
}

Future<void> addQuestion(String authKey, Map data) async {
  final response = await http.post(
    Uri.parse('https://api.github.com/repos/CrowdSolve/data/issues'),
    headers: <String, String>{
      'Authorization': 'token ' + authKey,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.statusCode);
  }
}

Future<void> lockQuestion(String authKey, int questionId) async {
  final response = await http.post(
    Uri.parse('https://api.github.com/repos/CrowdSolve/data/issues/$questionId/lock'),
    headers: <String, String>{
      'Authorization': 'token ' + authKey,
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.statusCode);
  }
}
Future<void> addComment(String authKey, Map data, int questionId) async {
  final response = await http.post(
    Uri.parse(
        'https://api.github.com/repos/CrowdSolve/data/issues/${questionId}/comments'),
    headers: <String, String>{
      'Authorization': 'token ' + authKey,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.statusCode);
  }
}

Future<String> uploadImage(filepath) async {
  var url = Uri.parse('https://api.imgur.com/3/image');
  var request = http.MultipartRequest('POST', url,);
  request.files.add(await http.MultipartFile.fromPath('image', filepath));
  request.headers['Authorization'] = 'Client-ID 50eef72dc333c55';
  http.Response response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 201) {
  } else {
    print(response.statusCode);
  }
  String uploadedImageUrl = jsonDecode(response.body)['data']['link'];
  return uploadedImageUrl;
}

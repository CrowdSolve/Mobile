
import 'dart:convert';


import 'package:cs_mobile/screens/main_screen/models/label.dart';
import 'package:http/http.dart' as http;


Future<List<Label>> fetchLabels() async {
  final response = await http.get(
    Uri.parse('https://api.github.com/search/labels?q=C-&repository_id=473928724'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var tagObjsJson = jsonDecode(response.body)["items"] as List;
    List<Label> tagObjs =
        tagObjsJson.map((tagJson) => Label.fromJson(tagJson)).toList();
    return tagObjs;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to load album');
  }
}

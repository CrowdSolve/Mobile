import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<Questions> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetch();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureAlbum,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              for (var item in snapshot.data!.questions) Text(item.userId)
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

Future<Questions> fetch() async {
  final response = await http
      .get(Uri.parse('https://api.gitrows.com/@github/CrowdSolve/data/test1.json'));

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

class Questions {
  final List<Question> questions;

  const Questions({
    required this.questions,
  });

  factory Questions.fromJson(List json) {
    return Questions(
      questions: (json as List).map((i) => Question.fromJson(i)).toList(),
    );
  }
}

class Question {
  final String userId;

  const Question({
    required this.userId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      userId: json["title"],
    );
  }
}

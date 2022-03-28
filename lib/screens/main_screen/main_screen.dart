import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../top_level_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late Future<Questions> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetch();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);

    return Material(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => createAlbum(githubOAuthKeyModel),
        ),
        body: FutureBuilder(
        future: futureAlbum,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(githubOAuthKeyModel),
                for (var item in snapshot.data!.questions) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.userId),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
      )
    );
  }
}




Future<void> createAlbum(String authKey) async {
  final response = await http.post(
    Uri.parse('https://api.github.com/repos/CrowdSolve/data/issues'),
    headers: <String, String>{
      'Authorization': 'token '+ authKey,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title':'test' ,
    }),
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

Future<Questions> fetch() async {
  final response = await http
      .get(Uri.parse('https://api.github.com/repos/flutter/flutter/issues?page=1&per_page=2'));

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

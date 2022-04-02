import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../top_level_provider.dart';
import 'models/question.dart';
import 'services/questions_service.dart';
import 'widgets/add_question.dart';

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

    return Material(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'add',
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder<void>(
                opaque: false,
                pageBuilder: (_, __, ___) => const Hero(
                  tag: 'add',
                  child: SafeArea(child: AddQuestion()),
                ),
              ),
            );
          },
          child: const Icon(Icons.add_comment_rounded),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: futureAlbum,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var item in snapshot.data!.questions)
                      Padding(
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
        ),
      ),
    );
  }
}

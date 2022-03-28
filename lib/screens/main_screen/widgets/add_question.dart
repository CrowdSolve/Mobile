import 'dart:async';
import 'dart:convert';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AddQuestion extends ConsumerStatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends ConsumerState<AddQuestion> {
  bool _validated = false;


  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _bodyFocusNode = FocusNode();
  
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);


    Future<void> _submit(String authKey) async {
      final response = await http.post(
        Uri.parse('https://api.github.com/repos/CrowdSolve/data/issues'),
        headers: <String, String>{
          'Authorization': 'token ' + authKey,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': _titleController.text,
          'body': _bodyController.text
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

    Future<void> _trySubmit(BuildContext context) async {
      try {
        await _submit(githubOAuthKeyModel);
      } catch (e) {
        unawaited(showExceptionAlertDialog(
          context: context,
          title: "Failed",
          exception: e,
        ));
      } finally {
        Navigator.pop(context);
      }
    }

    Future<void> _confirmSubmit(BuildContext context) async {
      final bool didRequestSignOut = await showAlertDialog(
            context: context,
            title: "Create question",
            content: "Are you sure",
            cancelActionText: "Cancel",
            defaultActionText: "Ask",
          ) ??
          false;
      if (didRequestSignOut == true) {
        await _trySubmit(context);
      }
    }
    var inputDecoration = InputDecoration(border: InputBorder.none);
    return Scaffold(
      body:Column(
        children: [
          SizedBox(
            height: 56,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text(
                  "Ask a question",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed:
                      _validated ? () => _confirmSubmit(context) : null,
                  child: Text("Save"),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,                
                onChanged: (){
                  bool _condition = !(_titleController.text.isEmpty || _bodyController.text.isEmpty);
                  if(_validated !=_condition){
                    setState(() {
                      _validated = _condition;
                    });
                  }
                },
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      maxLength: 20,
                      maxLines: 1,
                      decoration: inputDecoration.copyWith(hintText: "Title", ),
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _bodyController,
                        focusNode: _bodyFocusNode,
                        maxLines: 99,
                        decoration: inputDecoration.copyWith(hintText: "Body"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ), 
    );
  }
}
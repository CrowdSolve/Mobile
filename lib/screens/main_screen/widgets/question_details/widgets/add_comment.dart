import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class AddComment extends ConsumerStatefulWidget {
  final int questionId;
  const AddComment({Key? key, required this.questionId,}) : super(key: key);

  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends ConsumerState<AddComment> {

  bool _validated = false;


  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _bodyFocusNode = FocusNode();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);



    Future<void> _trySubmit(BuildContext context) async {
      try {
        await addComment(githubOAuthKeyModel,
            <String, String>{'body': _bodyController.text}, widget.questionId);
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
            title: "Add a comment",
            content: "Are you sure",
            cancelActionText: "Cancel",
            defaultActionText: "Comment",
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
                  "Add a comment",
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
                  bool _condition = !_bodyController.text.isEmpty;
                  if(_validated !=_condition){
                    setState(() {
                      _validated = _condition;
                    });
                  }
                },
                child: Expanded(
                  child: TextFormField(
                    controller: _bodyController,
                    focusNode: _bodyFocusNode,
                    maxLines: 99,
                    decoration: inputDecoration.copyWith(hintText: "Body"),
                  ),
                ),
              ),
            ),
          )
        ],
      ), 
    );
  }
}
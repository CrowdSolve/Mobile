import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:flutter/material.dart';

void wrapText(_bodyController, selection, start, end, String wrapee) {
  int wrapeeLength = wrapee.length;
  var _rec = _bodyController;
  final before = _rec.text.substring(0, start);
  final content = _rec.text.substring(start, end);
  final after = _rec.text.substring(_rec.selection.end);

  if (before.endsWith(wrapee) && after.startsWith(wrapee)) {
    _rec.text = before.substring(0, before.length - wrapeeLength) +
        content +
        after.substring(wrapeeLength);
    _rec.selection = TextSelection(
        baseOffset: start - wrapeeLength, extentOffset: end - wrapeeLength);
  } else {
    _rec.value = TextEditingValue(
      text: before + wrapee + content + wrapee + after,
      selection: TextSelection(
          baseOffset: start + wrapeeLength, extentOffset: end + wrapeeLength),
    );
  }
}

void insertText(String inserted, TextEditingController _controller) {
  final text = _controller.text;
  final selection = _controller.selection;
  final newText = text.replaceRange(selection.start, selection.end, inserted);
  _controller.value = TextEditingValue(
    text: newText,
    selection:
        TextSelection.collapsed(offset: selection.baseOffset + inserted.length),
  );
}

Future<bool> onWillPop(context) async {
  return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Unsaved changes'),
                content:
                    Text('Do you really want to discard your current changes?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Discard'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              )) ??
      false;
}

Future<void> confirmSubmitQuestion(
    context, githubOAuthKeyModel, title, body) async {
  Future<void> trySubmit() async {
    try {
      await addQuestion(
          githubOAuthKeyModel, <String, String>{'title': title, 'body': body});
      Navigator.pop(context);
    } catch (e) {
      unawaited(showExceptionAlertDialog(
        context: context,
        title: "Failed",
        exception: e,
      ));
    }
  }

  final bool didRequestSignOut = await showAlertDialog(
        context: context,
        title: "Create question",
        content: "Are you sure",
        cancelActionText: "Cancel",
        defaultActionText: "Ask",
      ) ??
      false;
  if (didRequestSignOut == true) {
    await trySubmit();
  }
}

Future<void> confirmSubmitComment(
    context, githubOAuthKeyModel, body, questionId) async {
  Future<void> _trySubmit() async {
    try {
      await addComment(
          githubOAuthKeyModel, <String, String>{'body': body}, questionId.toString());
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

  final bool didRequestSignOut = await showAlertDialog(
        context: context,
        title: "Add a comment",
        content: "Are you sure?",
        cancelActionText: "Cancel",
        defaultActionText: "Comment",
      ) ??
      false;
  if (didRequestSignOut == true) {
    await _trySubmit();
  }
}

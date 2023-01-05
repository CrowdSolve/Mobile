import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/models/comment.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/categories_dialog.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'helpers.dart';

import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';


enum _MDEditorMode { addQuestion, addComment, editComment }

class MDEditor extends ConsumerStatefulWidget {
  final String? questionId;
  final Comment? comment;
  final String title;

  final _MDEditorMode mode;

  const MDEditor.question()
      : this.mode = _MDEditorMode.addQuestion,
        this.title = 'Add Question',
        this.questionId = null,
        this.comment = null;
  const MDEditor.comment({
    required this.questionId,
  })  : this.mode = _MDEditorMode.addComment,
        this.title = 'Add Comment',
        this.comment = null;

  const MDEditor.editComment({
    required this.comment,
  })  : this.mode = _MDEditorMode.editComment,
        this.title = 'Edit Comment',
        this.questionId = null;

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends ConsumerState<MDEditor> {
  bool _validated = false;
  bool _loading = false;

  TextEditingController _titleController = TextEditingController();
  final QuillController controller = QuillController.basic();

  FocusNode _titleFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<String?> _onImageButtonPressed(pickedFile) async {
    String? pickedImagePath;
    try {
      setState(() {
        _loading = true;
      });
      pickedImagePath = await uploadImage(pickedFile.path);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      });
    }
  return pickedImagePath;
  }

  String query = "";
  bool preview = false;

  @override
  Widget build(BuildContext context) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);

    var inputDecoration = InputDecoration(border: InputBorder.none);
    return WillPopScope(
      onWillPop: (() => onWillPop(context)),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
              ),
              onPressed: () async =>
                  await onWillPop(context) ? Navigator.pop(context) : null),
          titleSpacing: 6,
          actions: [
            if (widget.mode == _MDEditorMode.addQuestion)
              TextButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 100),
                      child: Text(
                          query.isEmpty ? "No Label" : query.substring(2),
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () async {
                  query = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => CategoriesDialog())) ??
                      "";
                  setState(() {});
                },
              ),
            IconButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              onPressed: !(_validated && !_loading)
                  ? null
                  : () {
                      switch (widget.mode) {
                        case _MDEditorMode.addQuestion:
                          {
                            confirmSubmitQuestion(
                                context,
                                githubOAuthKeyModel,
                                _titleController.text,
                                getMarkdown(controller.document) +
                                    '\n\n' +
                                    '[tags]:- "$query,"');
                          }
                          break;

                        case _MDEditorMode.addComment:
                          {
                            confirmSubmitComment(context, githubOAuthKeyModel,
                                getMarkdown(controller.document), widget.questionId!);
                          }
                          break;
                        case _MDEditorMode.editComment:
                          {
                            confirmEditComment(context, githubOAuthKeyModel,
                                getMarkdown(controller.document), widget.comment!.id);
                          }
                          break;
                      }
                    },
              icon: Icon(
                Icons.send_rounded,
                size: 22,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: () {
                    //Check if form is validated and update state
                    bool _condition = (!controller.document.isEmpty() &&
                        (_titleController.text.isNotEmpty ||
                            widget.mode == _MDEditorMode.addQuestion));
                    if (_validated != _condition) {
                      setState(() {
                        _validated = _condition;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      if (widget.mode == _MDEditorMode.addQuestion)
                        TextFormField(
                          controller: _titleController,
                          focusNode: _titleFocusNode,
                          maxLength: 20,
                          maxLines: 1,
                          decoration: inputDecoration.copyWith(
                            hintText: "Title",
                          ),
                          style: TextStyle(fontSize: 20),
                        ),
                      Expanded(
                        child: IndexedStack(
                          index: preview ? 0 : 1,
                          children: [
                            Markdown(
                              selectable: true,
                              styleSheet: MarkdownStyleSheet(
                                p: Theme.of(context).textTheme.bodyText1,
                              ),
                              data: getMarkdown(controller.document),
                              padding: EdgeInsets.only(top: 12),
                            ),
                            Positioned.fill(
                              child: QuillEditor.basic(
                                controller: controller,
                                readOnly: false,
                                embedBuilders: FlutterQuillEmbeds.builders(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            QuillToolbar.basic(
              controller: controller,
              iconTheme: QuillIconTheme(
                  iconSelectedFillColor: Theme.of(context).colorScheme.primary,
                  iconSelectedColor: Theme.of(context).colorScheme.onPrimary,
                  ),
              //Disable unsupported tools
              showStrikeThrough: false,
              showUnderLineButton: false,
              showAlignmentButtons: false,
              showColorButton: false,
              showCenterAlignment: false,
              showDirection: false,
              showBackgroundColorButton: false,
              showInlineCode: false,
              showIndent: false,
              multiRowsDisplay: false,
              showJustifyAlignment: false,
              showFontFamily: false,
              showFontSize: false,
              showListCheck: false,
              showListNumbers: false,
              embedButtons: FlutterQuillEmbeds.buttons(
                onImagePickCallback: _onImageButtonPressed,
                showCameraButton:
                    false, //TODO: fix camera button and try to integrate the formula button
                showFormulaButton: false,
                showVideoButton: false,
                mediaPickSettingSelector: selectMediaPickSetting,
              ),
              customButtons: [
                QuillCustomButton(
                    icon: preview ? Icons.edit : Icons.preview,
                    onTap: () {
                      if (!preview)
                        FocusManager.instance.primaryFocus!.unfocus();
                      setState(() => preview = !preview);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


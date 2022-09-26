import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/models/comment.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/categories_dialog.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_selection_controls/text_selection_controls.dart';

import 'helpers.dart';

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

  TextEditingController _titleController = TextEditingController(),
      _bodyController = TextEditingController();
  FocusNode _titleFocusNode = FocusNode(), _bodyFocusNode = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed() async {
    try {
      setState(() {
        _loading = true;
      });
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      String pickedImagePath = await uploadImage(pickedFile!.path);
      insertText('![]($pickedImagePath)', _bodyController);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        showExceptionAlertDialog(
            context: context, title: 'Error occured', exception: e);
      });
    }
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
        floatingActionButton: IconButton(
            icon: Icon(preview ? Icons.edit : Icons.preview),
            onPressed: () {
              if (!preview) FocusManager.instance.primaryFocus!.unfocus();
              setState(() => preview = !preview);
            }),
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
                                _bodyController.text +
                                    '\n\n' +
                                    '[tags]:- "$query,"');
                          }
                          break;

                        case _MDEditorMode.addComment:
                          {
                            confirmSubmitComment(context, githubOAuthKeyModel,
                                _bodyController.text, widget.questionId!);
                          }
                          break;
                        case _MDEditorMode.editComment:
                          {
                            confirmEditComment(context, githubOAuthKeyModel,
                                _bodyController.text, widget.comment!.id);
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              //Check if form is validated and update state
              bool _condition = (_bodyController.text.isNotEmpty &&
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
                        data: _bodyController.text,
                        padding: EdgeInsets.only(top: 12),
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyText1,
                        selectionControls: FlutterSelectionControls(
                            verticalPadding: 14,
                            horizontalPadding: 12,
                            toolBarItems: <ToolBarItem>[
                              ToolBarItem(
                                  item: Icon(Icons.cut_rounded),
                                  itemControl: ToolBarItemControl.cut),
                              ToolBarItem(
                                  item: Icon(Icons.copy_rounded),
                                  itemControl: ToolBarItemControl.copy),
                              ToolBarItem(
                                  item: Icon(Icons.paste_rounded),
                                  itemControl: ToolBarItemControl.paste),
                              ToolBarItem(
                                  item: Icon(Icons.select_all_rounded),
                                  itemControl: ToolBarItemControl.selectAll),
                              ToolBarItem(
                                item: Icon(Icons.format_bold_rounded),
                                onItemPressed: (content, start, end) =>
                                    wrapText(_bodyController, content, start,
                                        end, '**'),
                              ),
                              ToolBarItem(
                                item: Icon(Icons.format_italic_rounded),
                                onItemPressed: (content, start, end) =>
                                    wrapText(_bodyController, content, start,
                                        end, '*'),
                              ),
                              ToolBarItem(
                                item: Icon(Icons.format_strikethrough_rounded),
                                onItemPressed: (content, start, end) =>
                                    wrapText(_bodyController, content, start,
                                        end, '~~'),
                              ),
                              ToolBarItem(
                                item: !_loading
                                    ? Icon(Icons.add_photo_alternate_rounded)
                                    : CircularProgressIndicator(),
                                onItemPressed: (content, start, end) =>
                                    !_loading ? _onImageButtonPressed() : null,
                              ),
                            ]),
                        controller: _bodyController,
                        focusNode: _bodyFocusNode,
                        maxLines: 99,
                        decoration: inputDecoration.copyWith(hintText: "Body"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

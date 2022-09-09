import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_selection_controls/text_selection_controls.dart';

import 'helpers.dart';

class MDEditor extends ConsumerStatefulWidget {
  final bool isTitleIncluded;
  final int? questionId;

  const MDEditor.question({Key? key,}) : questionId = null,isTitleIncluded = true, super(key: key);
  const MDEditor.comment({Key? key, required this.questionId,}) : isTitleIncluded = false ,super(key: key);


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

  @override
  Widget build(BuildContext context) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);

    var inputDecoration = InputDecoration(border: InputBorder.none);
    return WillPopScope(
      onWillPop: (() => onWillPop(context)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isTitleIncluded?'Ask a question':'Add a comment'),
          leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
              ),
              onPressed: () async =>
                  await onWillPop(context) ? Navigator.pop(context) : null),
          actions: [
            TextButton(
              onPressed:_validated && !_loading? () {
                  widget.isTitleIncluded
                      ? confirmSubmitQuestion(context, githubOAuthKeyModel,_titleController.text, _bodyController.text)
                      : confirmSubmitComment(context, githubOAuthKeyModel,_bodyController.text, widget.questionId!);
                  
              }:null,
              child: Text("Save"),
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
              bool _condition = (_bodyController.text.isNotEmpty && (_titleController.text.isNotEmpty||!widget.isTitleIncluded));
              if (_validated != _condition) {
                setState(() {
                  _validated = _condition;
                });
              }
            },
            child: Column(
              children: [
                widget.isTitleIncluded?
                TextFormField(
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                  maxLength: 20,
                  maxLines: 1,
                  decoration: inputDecoration.copyWith(
                    hintText: "Title",
                  ),
                  style: TextStyle(fontSize: 20),
                ):SizedBox.shrink(),
                Expanded(
                  child: TextFormField(
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
                            onItemPressed: (content, start, end) => wrapText(
                                _bodyController, content, start, end, '**'),
                          ),
                          ToolBarItem(
                            item: Icon(Icons.format_italic_rounded),
                            onItemPressed: (content, start, end) => wrapText(
                                _bodyController, content, start, end, '*'),
                          ),
                          ToolBarItem(
                            item: Icon(Icons.format_strikethrough_rounded),
                            onItemPressed: (content, start, end) => wrapText(
                                _bodyController, content, start, end, '~~'),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

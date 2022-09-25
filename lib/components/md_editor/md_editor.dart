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

class MDEditor extends ConsumerStatefulWidget {
  final bool isTitleIncluded;

  final String? questionId;
  final Comment? comment;

  const MDEditor.question({Key? key,}) : this.questionId = null,this.isTitleIncluded = true, this.comment = null, super(key: key);
  const MDEditor.comment({Key? key, required this.questionId,}) :  this.isTitleIncluded = false ,this.comment = null,super(key: key);

  const MDEditor.editComment({Key? key, required this.comment}) : this.questionId=null, this. isTitleIncluded = false ,super(key: key);


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
            icon: Icon(preview?Icons.edit:Icons.preview),
            onPressed: () {
              if(!preview)FocusManager.instance.primaryFocus!.unfocus();
              setState(() => preview = !preview);
            }),
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(widget.isTitleIncluded?'Ask a question':'Add a comment'),
          leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 24,
              ),
              onPressed: () async =>
                  await onWillPop(context) ? Navigator.pop(context) : null),
          titleSpacing: 6,
          actions: [
            if(widget.isTitleIncluded)
            TextButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(query.isEmpty
                        ? "No Label"
                        : query.substring(2), style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero,),
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
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact,),
              onPressed:_validated && !_loading? () {
                  widget.isTitleIncluded
                      ? confirmSubmitQuestion(context, githubOAuthKeyModel,_titleController.text, _bodyController.text +'\n\n'+'[tags]:- "$query,"')
                      : widget.comment!=null?confirmEditComment(context, githubOAuthKeyModel,_bodyController.text,widget.comment!.id):
                      confirmSubmitComment(context, githubOAuthKeyModel,_bodyController.text, widget.questionId!);
                  
              }:null,
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
                  child: IndexedStack(
                    index: preview?0:1,
                    children: [
                      Markdown(
                        selectable: true,
                        styleSheet: MarkdownStyleSheet(p: Theme.of(context).textTheme.bodyText1,),
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

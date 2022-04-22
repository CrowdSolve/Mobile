import 'dart:async';

import 'package:alert_dialogs/alert_dialogs.dart';
import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_selection_controls/text_selection_controls.dart';


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

  XFile? _imageFile;
  String? _retrieveDataError;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();

  bool _loading = false;

  Future<bool> _onWillPop() async {
    return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Unsaved changes'),
                  content: Text(
                      'Do you really want to discard your current changes?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Discard'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                )) ??
        false;
  }
  void _insertText(String inserted, TextEditingController _controller) {
      final text = _controller.text;
      final selection = _controller.selection;
      final newText =
          text.replaceRange(selection.start, selection.end, inserted);
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: selection.baseOffset + inserted.length),
      );
    }

  Future<void> _onImageButtonPressed() async {
    try {
      setState(() {
        _loading = true;
      });
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      String pickedImagePath = await uploadImage(pickedFile!.path);
      _insertText('![]($pickedImagePath)', _bodyController);
      setState(() {
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        showExceptionAlertDialog(context: context, title: 'Error occured', exception: e);
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);


    

    Future<void> _trySubmit(BuildContext context) async {
      try {
        await addQuestion(githubOAuthKeyModel, <String, String>{
          'title': _titleController.text,
          'body': _bodyController.text
        });
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                      onPressed: () async =>
                            await _onWillPop() ? Navigator.pop(context) : null
                    ),
                  ),
                  Text(
                    "Ask a question",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: !_loading?() => _onImageButtonPressed():null,
                      icon: !_loading?Icon(Icons.attach_file_rounded):CircularProgressIndicator()),
                  TextButton(
                    onPressed:
                        _validated && !_loading? () => _confirmSubmit(context) : null,
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
                          selectionControls: FlutterSelectionControls(verticalPadding: 14, horizontalPadding: 16,toolBarItems: <ToolBarItem>[
                            ToolBarItem(
                                item: Text(
                                  'Cut',
                                ),
                                itemControl: ToolBarItemControl.cut),
                            ToolBarItem(
                                item: Text(
                                  'Copy',
                                ),
                                itemControl: ToolBarItemControl.copy),
                            ToolBarItem(
                                item: Text(
                                  'Paste',
                                ),
                                itemControl: ToolBarItemControl.paste),
                            ToolBarItem(
                                item: Text(
                                  'Select All',
                                ),
                                itemControl: ToolBarItemControl.selectAll),
                            ToolBarItem(
                                item: Text(
                                  'Bold',
                                ),
                                onItemPressed: (content, start, end) =>
                                      wrapText(content, start, end, '**'),
                                ),
                                ToolBarItem(
                                    item: Text(
                                      'Italic',
                                    ),
                                onItemPressed: (content, start, end) =>
                                      wrapText(content, start, end, '*'),
                                ),
                            ToolBarItem(
                                item: Text(
                                  'Strikethrough',
                                ),
                                onItemPressed: (content, start, end) =>
                                      wrapText(content, start, end, '~~'),
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
            )
          ],
        ), 
      ),
    );
  }

  wrapText(selection, start, end, String wrapee) {
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
}

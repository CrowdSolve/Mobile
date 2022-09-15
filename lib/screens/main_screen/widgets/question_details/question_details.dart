import 'package:cs_mobile/screens/main_screen/models/comment.dart';
import 'package:cs_mobile/screens/main_screen/models/question.dart';
import 'package:cs_mobile/screens/main_screen/widgets/animated_fab.dart';
import 'package:cs_mobile/screens/main_screen/widgets/md_editor/md_editor.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_details/widgets/comment_card.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_details/widgets/expanded_question_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '../../services/questions_service.dart';

class QuestionDetails extends StatefulWidget {
  final int id;
  final Question question;

  static DateFormat f = DateFormat('MM/dd hh:mm');
  const QuestionDetails({Key? key, required this.id, required this.question})
      : super(key: key);

  @override
  State<QuestionDetails> createState() => _QuestionDetailsState();
}

class _QuestionDetailsState extends State<QuestionDetails> {
  static const _pageSize = 5;

  final PagingController<int, Comment> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await Future.delayed(Duration(milliseconds: 500),()=>fetchCommentsWithIssueId(widget.id, pageKey));
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        floatingActionButton: AnimatedFAB(openWidget: MDEditor.comment(questionId: widget.id,)),
        body: ListView(
          children: [
            ExpandedQuestionCard(question: widget.question),
            Divider(thickness: 2,),
            PagedListView<int, Comment>.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              pagingController: _pagingController,
              separatorBuilder: (context, index) => Divider(thickness: 1,),
              builderDelegate: PagedChildBuilderDelegate<Comment>(
                itemBuilder: (context, item, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CommentCard(comment: item),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

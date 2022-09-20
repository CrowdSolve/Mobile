import 'package:cs_mobile/components/animated_fab.dart';
import 'package:cs_mobile/components/md_editor/md_editor.dart';
import 'package:cs_mobile/models/comment.dart';
import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/screens/questions_screen/shared_components/question_details/widgets/comment_card.dart';
import 'package:cs_mobile/screens/questions_screen/shared_components/question_details/widgets/expanded_question_card.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/error_indicator.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';


class QuestionDetails extends StatefulWidget {
  final String? id;
  final Question? question;

  static DateFormat f = DateFormat('MM/dd hh:mm');
  const QuestionDetails({Key? key, required this.id, this.question})
      : super(key: key);

  @override
  State<QuestionDetails> createState() => _QuestionDetailsState();
}

class _QuestionDetailsState extends State<QuestionDetails> {
  static const _pageSize = 5;

  final PagingController<int, Comment> _pagingController =
      PagingController(firstPageKey: 0);

  late Future<Question> question;
  @override
  void initState() {
    if(widget.question != null){
      _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    }
    else if(widget.id != null){
      question = fetchWithId(widget.id!);
    }
    
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await Future.delayed(Duration(milliseconds: 500),()=>fetchCommentsWithIssueId(widget.question!.id, pageKey));
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
            widget.question != null?ExpandedQuestionCard(question: widget.question!):
            FutureBuilder<Question>(
              future: question,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ExpandedQuestionCard(question: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(child:  CircularProgressIndicator());
              },
            ),
            Divider(thickness: 2,),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text('Comments', style: Theme.of(context).textTheme.headline6,),
            ),
            PagedListView<int, Comment>.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              pagingController: _pagingController,
              separatorBuilder: (context, index) => Divider(thickness: 1,),
              builderDelegate: PagedChildBuilderDelegate<Comment>(
                firstPageErrorIndicatorBuilder:(context) => ErrorIndicator(
                  onTryAgain: () => _pagingController.refresh(),
                ),
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

import 'package:cs_mobile/models/answer.dart';
import 'package:cs_mobile/models/comment.dart';
import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/screens/questions_screen/shared_components/question_card.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/error_indicator.dart';
import 'package:cs_mobile/services/answers_service.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


class MyAnswers extends ConsumerStatefulWidget {
  final userLogin;
  const MyAnswers(this.userLogin, {Key? key}) : super(key: key);

  @override
  _MyAnswersState createState() => _MyAnswersState();
}

class _MyAnswersState extends ConsumerState<MyAnswers> {
  static const _pageSize = 5;

  final PagingController<int, Question> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
     _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey,);
    });
    super.initState();
  }
  Future<void> _fetchPage(int pageKey, ) async {
    try {
      final newItems = await fetchWithQuery(pageKey, searchTerm:  'author:' + widget.userLogin + '&labels=visible');
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
    return Material(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12,),
              child: PagedListView<int, Question>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Question>(
                      firstPageErrorIndicatorBuilder:(context) => ErrorIndicator(
                  onTryAgain: () => _pagingController.refresh(),
                ),
                      itemBuilder: (context, item, index) {
                        if(index == 0)
                        return Column(
                          children: [
                            SizedBox(height: 20,),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Questions you answered', style: Theme.of(context).textTheme.headline4,),
                            ),
                            SizedBox(height: 20,),
                            QuestionCard(question: item,),
                          ],
                        );
                        else
                        return QuestionCard(question: item,);
                      },
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
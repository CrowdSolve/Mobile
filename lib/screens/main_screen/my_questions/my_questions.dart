import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/question.dart';
import '../services/questions_service.dart';
import '../widgets/question_card.dart';
import '../widgets/question_card_with_image.dart';

class MyQuestions extends ConsumerStatefulWidget {
  final userLogin;
  const MyQuestions(this.userLogin, {Key? key}) : super(key: key);

  @override
  _MyQuestionsState createState() => _MyQuestionsState();
}

class _MyQuestionsState extends ConsumerState<MyQuestions> {
  static const _pageSize = 5;

  final PagingController<int, Question> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
     _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, widget.userLogin);
    });
    super.initState();
  }
  Future<void> _fetchPage(int pageKey, userLogin) async {
    try {
      final newItems = await fetchWithQuery(pageKey, searchTerm: 'author:'+ userLogin);
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
                      itemBuilder: (context, item, index) {
                        if (item.imageUrl == '') {
                          return QuestionCard(question: item);
                        } else {
                          return QuestionCardWithImage(question: item);
                        }
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
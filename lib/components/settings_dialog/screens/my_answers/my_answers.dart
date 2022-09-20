import 'package:cs_mobile/models/answer.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/error_indicator.dart';
import 'package:cs_mobile/services/answers_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


class MyAnswers extends ConsumerStatefulWidget {
  final authKey;
  const MyAnswers(this.authKey, {Key? key}) : super(key: key);

  @override
  _MyAnswersState createState() => _MyAnswersState();
}

class _MyAnswersState extends ConsumerState<MyAnswers> {
  static const _pageSize = 5;

  final PagingController<int, Answer> _pagingController =
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
      final newItems = await fetchAnswers(widget.authKey, pageKey, );
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
              child: PagedListView<int, Answer>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Answer>(
                      firstPageErrorIndicatorBuilder:(context) => ErrorIndicator(
                  onTryAgain: () => _pagingController.refresh(),
                ),
                      itemBuilder: (context, item, index) {
                        return Text(item.title);
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
import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_card.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_card_with_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/question.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 5;

  final PagingController<int, Question> _pagingController =
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
      final newItems = await fetch(pageKey);
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
      child: ListView(
        children: 
          [
            SizedBox(
              height: 50,
            ),
            Text(
              "Recommended for you",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            PagedListView<int, Question>(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
          ],
      ),
    );
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
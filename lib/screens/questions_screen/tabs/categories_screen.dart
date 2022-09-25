import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/screens/questions_screen/shared_components/question_card.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'widgets/categories_dialog.dart';
import 'widgets/error_indicator.dart';


class CategoriesScreen extends StatefulWidget {
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  String query = "";

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
      final newItems = await fetchWithQuery(pageKey, searchTerm: query.isEmpty?'label:visible':'label:' + query + '+label:visible');
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
        padding: const EdgeInsets.only(top: 10),
        children: 
          [
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(query.isEmpty ? "All Categories" : query.substring(2)),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
                style: OutlinedButton.styleFrom(),
                onPressed: () async {
                  query = await Navigator.push(
            context,
            MaterialPageRoute(fullscreenDialog: true,builder: (context) => CategoriesDialog())
          )??"";
          _pagingController.refresh();
          setState(() {
            
          });
                },
              ),
            ),
            PagedListView<int, Question>(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Question>(
                firstPageErrorIndicatorBuilder:(context) => ErrorIndicator(
                  onTryAgain: () => _pagingController.refresh(),
                ),
                itemBuilder: (context, item, index) => QuestionCard(question: item,)
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
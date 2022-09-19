import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../screens/questions_screen/shared_components/question_card.dart';

class Search extends SearchDelegate {
  static const _pageSize = 5;

  final PagingController<int, Question> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _pagingController.refresh();
    _fetchPage();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PagedListView<int, Question>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Question>(
          itemBuilder: (context, item, index) => QuestionCard(question: item),
        ),
      ),
    ); 
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox.shrink();
  }
  
  Future<void> _fetchPage() async {
    int pageKey = 0;
    try {
      final newItems = await fetchWithQuery(
        pageKey,
        searchTerm: query + '+label:visible',
      );

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
}



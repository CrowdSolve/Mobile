import 'dart:async';
import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_card.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_details/question_details.dart';
import 'package:cs_mobile/screens/main_screen/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../top_level_provider.dart';
import 'models/question.dart';
import 'services/questions_service.dart';
import 'widgets/add_question.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    return Material(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'add',
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder<void>(
                opaque: false,
                pageBuilder: (_, __, ___) => const Hero(
                  tag: 'add',
                  child: SafeArea(child: AddQuestion()),
                ),
              ),
            );
          },
          child: const Icon(Icons.add_comment_rounded),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SearchButton(),
                  SizedBox(height: 50,),
                  Text("Recommended for you", style: Theme.of(context).textTheme.titleLarge,),
                  PagedListView<int, Question>(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Question>(
                      itemBuilder: (context, item, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: OpenContainer(
                          closedColor: Colors.white10,
                          closedShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          openColor: Colors.black,
                          closedBuilder: (_, __) =>
                              QuestionCard(question: item),
                          openBuilder: (_, __) => QuestionDetails(id: item.id),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

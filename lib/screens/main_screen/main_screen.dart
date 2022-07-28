import 'dart:async';
import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_card.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_card_with_image.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_details/question_details.dart';
import 'package:cs_mobile/screens/main_screen/widgets/search_button/widgets/search_button.dart';
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

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: SearchButton(),
              pinned: true,
              floating: true,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Theme.of(context).colorScheme.background,
              forceElevated: boxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: <Widget>[
                  Tab(
                    text: "Home",
                  ),
                  Tab(
                    text: "Example page",
                  )
                ],
              ),
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
          child: TabBarView(
            children: <Widget>[
              ForYouFilter(pagingController: _pagingController,),
              ForYouFilter(pagingController: _pagingController,)
            ],
          ),
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

class ForYouFilter extends StatelessWidget {
  const ForYouFilter({
    Key? key,
    required PagingController<int, Question> pagingController,
  }) : _pagingController = pagingController, super(key: key);

  final PagingController<int, Question> _pagingController;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}

import 'package:cs_mobile/screens/main_screen/screens/categories_screen.dart';
import 'package:cs_mobile/screens/main_screen/widgets/search_button/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'widgets/add_question.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0,surfaceTintColor: Colors.transparent,),
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
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                Tab(
                  text: "Home",
                ),
                Tab(
                  text: "Categories",
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
            HomeScreen(),
            CategoriesScreen()
          ],
        ),
        ),
      ),
        ),
      ),
    );
  } 
}
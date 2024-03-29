import 'package:cs_mobile/screens/questions_screen/tabs/categories_screen.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/course_screen.dart';
import 'package:cs_mobile/components/search_button/search_button.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tabs/home_screen.dart';
import '../../components/animated_fab.dart';
import '../../components/md_editor/md_editor.dart';

class QuestionsScreen extends ConsumerStatefulWidget {
  const QuestionsScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<QuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    final signedIn = ref.watch(firebaseAuthProvider).currentUser != null;
    final authKey = ref.watch(githubOAuthKeyModelProvider);
    return Scaffold(
      appBar:AppBar(toolbarHeight: 0,surfaceTintColor: Colors.transparent,),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: signedIn? AnimatedFAB(openWidget: MDEditor.question(), label: 'Ask a question', icon: Icons.add_comment):null,
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  padding: EdgeInsets.only(left: 16),
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  tabs: <Widget>[
                    Tab(
                      text: "Home",
                    ),
                    Tab(
                      text: "Categories",
                    ),
                    Tab(
                      text: "Course & College",
                    )
                  ],
                ),
              ),
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
            HomeScreen(authKey:authKey),
            CategoriesScreen(authKey:authKey),
            CourseScreen(authKey:authKey)
          ],
        ),
        ),
      ),
        ),
      ),
    );
  } 
}
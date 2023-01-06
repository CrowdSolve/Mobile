import 'package:cs_mobile/components/profile_screen/components/full_user_info.dart';
import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/screens/questions_screen/shared_components/question_card.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/error_indicator.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final UserModel? user;

  const ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final signedIn = ref.watch(firebaseAuthProvider).currentUser != null;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.user!.avatarUrl),
                    radius: 60,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    widget.user!.login,
                    style: GoogleFonts.roboto(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          signedIn
              ? FullUserInfo(userLogin: widget.user!.login)
              : SizedBox.shrink(),
          UserQuestions(userLogin: widget.user!.login),
        ],
      ),
    );
  }
}

class UserQuestions extends StatefulWidget {
  final String userLogin;

  const UserQuestions({Key? key, required this.userLogin}) : super(key: key);
  @override
  State<UserQuestions> createState() => _UserQuestionsState();
}

class _UserQuestionsState extends State<UserQuestions> {
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
      final newItems = await fetchWithQuery(pageKey,
          searchTerm: 'author:' + userLogin + '&labels=visible');
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: PagedListView<int, Question>(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Question>(
              firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
                    onTryAgain: () => _pagingController.refresh(),
                  ),
              noItemsFoundIndicatorBuilder: (context) =>
                  Text('No questions found'),
              itemBuilder: (context, item, index) => index == 0
                  ? Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 44.0, bottom: 8.0),
                            child: Text(
                              "Questions by this user (" +
                                  _pagingController.itemList!.length
                                      .toString() +
                                  ')',
                              style: GoogleFonts.roboto(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        QuestionCard(
                          question: item,
                        ),
                      ],
                    )
                  : QuestionCard(
                      question: item,
                    )),
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

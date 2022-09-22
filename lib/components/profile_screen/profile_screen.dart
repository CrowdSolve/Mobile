import 'package:cs_mobile/components/profile_screen/components/full_user_info.dart';
import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/screens/questions_screen/shared_components/question_card.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/error_indicator.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;
  final String? userId;

  const ProfileScreen({Key? key, this.user, this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                  FullUserInfo(userId: widget.userId??widget.user!.id),
          UserQuestions(userId: widget.userId??widget.user!.id),
        ],
      ),
    );
  }
}

class UserQuestions extends StatefulWidget {
  final String userId;

  const UserQuestions({Key? key, required this.userId}) : super(key: key);
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
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await fetch(pageKey, searchTerm: 'user:' + widget.userId + '+labels=visible');
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
      child: Column(
        children: [
          if(_pagingController.itemList != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Questions by this user (" + _pagingController.itemList!.length.toString() + ')',
              style: GoogleFonts.roboto(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
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
              itemBuilder: (context, item, index) => QuestionCard(question: item)
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
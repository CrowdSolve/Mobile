import 'package:cs_mobile/models/label.dart';
import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/course_dialog.dart';
import 'package:cs_mobile/screens/questions_screen/tabs/widgets/inistitution_dialog.dart';
import 'package:cs_mobile/screens/questions_screen/shared_components/question_card.dart';
import 'package:cs_mobile/services/label_service.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/error_indicator.dart';



class CourseScreen extends StatefulWidget {
  final String authKey;

  const CourseScreen({Key? key, required this.authKey}) : super(key: key);
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {

  String course = "";
  String institution = "";



  static const _pageSize = 5;

  final PagingController<int, Question> _pagingController =
      PagingController(firstPageKey: 0);

  late SharedPreferences prefs;
  
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    List<String> _tags = [];

    if (course.isNotEmpty && institution.isNotEmpty) {
      _tags = [
        'label:"' + 'I-$institution' + ' : ' + 'C-$course' + '"',
      ];
    } else if (course.isEmpty && institution.isNotEmpty) {
      List<Label> labelsWithInstitution = await fetchLabels('I-' + institution);
      labelsWithInstitution.forEach((_courses) => _tags.add('"'+_courses.name + '"'));
    } else if (institution.isEmpty && course.isNotEmpty) {
      List<Label> labelsWithCourse= await fetchLabels('C-' + course);
      labelsWithCourse.forEach((_institution) => _tags.add('"'+_institution.name+ '"'));
    }


  String _searchTerm = _tags.isEmpty?'label:visible':'label:'+_tags.join(',') + '+label:visible';
    try {
      final newItems = await fetchWithQuery(pageKey, searchTerm: _searchTerm, authKey: widget.authKey);
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
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            prefs = snapshot.data!;
            institution = prefs.getString('institution') ?? '';
            course = prefs.getString('course') ?? '';
            return RefreshIndicator(
              onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 10),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        OutlinedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(institution.isEmpty
                                  ? "All Institutions"
                                  : institution),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          style: OutlinedButton.styleFrom(),
                          onPressed: () async {
                            institution = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            InistitutionDialog(
                                              course: course,
                                            ))) ??
                                "";
                            _pagingController.refresh();
                            setState(() {});
                            prefs.setString('institution', institution);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        OutlinedButton(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(course.isEmpty ? "All Courses" : course),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                          style: OutlinedButton.styleFrom(),
                          onPressed: () async {
                            course = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => CourseDialog(
                                              institution: institution,
                                            ))) ??
                                "";
                            _pagingController.refresh();
                            setState(() {});
                            prefs.setString('course', course);
                          },
                        ),
                      ],
                    ),
                  ),
                  PagedListView<int, Question>(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Question>(
                        firstPageErrorIndicatorBuilder: (context) =>
                            ErrorIndicator(
                              onTryAgain: () => _pagingController.refresh(),
                            ),
                        itemBuilder: (context, item, index) => QuestionCard(
                              question: item,
                            )),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
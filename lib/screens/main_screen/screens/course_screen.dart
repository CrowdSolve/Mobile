import 'package:cs_mobile/screens/main_screen/models/label.dart';
import 'package:cs_mobile/screens/main_screen/screens/widgets/course_dialog.dart';
import 'package:cs_mobile/screens/main_screen/screens/widgets/inistitution_dialog.dart';
import 'package:cs_mobile/screens/main_screen/services/label_service.dart';
import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/question.dart';


class CourseScreen extends StatefulWidget {
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {

  String course = "";
  String institution = "";



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
      final newItems = await fetchWithQuery(pageKey, searchTerm: _searchTerm);
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
                                builder: (context) => InistitutionDialog(course: course,))) ??
                        "";
                    _pagingController.refresh();
                    setState(() {});
                  },
                ),
                SizedBox(width: 10,),
                OutlinedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(course.isEmpty
                          ? "All Courses"
                          : course),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(),
                  onPressed: () async {
                    course = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => CourseDialog(institution: institution,))) ??
                        "";
                    _pagingController.refresh();
                    setState(() {});
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
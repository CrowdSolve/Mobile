import 'package:cs_mobile/screens/main_screen/models/question.dart';
import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:cs_mobile/screens/main_screen/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestionDetails extends StatelessWidget {
  final int id;
  final Question question;

  static DateFormat f = DateFormat('MM/dd hh:mm');
  const QuestionDetails({Key? key, required this.id, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuestionCard(question: question),
        FutureBuilder<Question>(
          future: fetchWithId(id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Question question = snapshot.data!;
              return Column(
                children: [
                  QuestionCard(question: question),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return Center(child: const CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}

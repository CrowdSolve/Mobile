import 'package:cs_mobile/screens/main_screen/models/question.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'question_details/question_details.dart';

class QuestionCard extends StatelessWidget {
  static DateFormat f = DateFormat('MM/dd hh:mm');
  final Question question;
  const QuestionCard({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 200),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionDetails(
                  id: question.id,
                  question: question,
                ),
              ),
            );
          },
          child: Hero(
            tag: 'question'+question.id.toString(),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(question.posterAvatarUrl),
                            radius: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            question.posterName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(' ● ${f.format(DateTime.now())}',
                              style: Theme.of(context).textTheme.labelSmall),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(question.title,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.fade),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            question.heart.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Icon(
                            Icons.comment,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            question.noOfComments.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

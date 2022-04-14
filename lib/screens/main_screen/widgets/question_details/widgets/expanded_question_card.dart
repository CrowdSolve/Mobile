import 'package:cs_mobile/screens/main_screen/models/question.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpandedQuestionCard extends StatelessWidget {
  final Question question;
  static DateFormat f = DateFormat('MM/dd hh:mm');

  const ExpandedQuestionCard({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'question'+question.id.toString(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  Text(' ● ${f.format(DateTime.parse(question.createdAt))}',
                      style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(question.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.fade),
              SizedBox(
                height: 20,
              ),
              Text(question.body,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.fade),
              SizedBox(
                height: 20,
              ),
              Row(
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
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}

import 'package:flutter/material.dart';

import '../models/question.dart';
import 'question_details/question_details.dart';

import 'package:timeago/timeago.dart' as timeago;
class QuestionCardWithImage extends StatelessWidget {
  final Question question;
  const QuestionCardWithImage({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp exp = RegExp(
      r"!\[]\(.*\)\n",
    );
    String body = question.body.replaceAll(exp, '');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 400),
        child: Hero(
          tag: 'question' + question.id.toString(),
          child: Card(
            clipBehavior: Clip.antiAlias,
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
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox.expand(
                        child:
                            Image.network(question.imageUrl!, fit: BoxFit.cover)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(question.title,
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Flexible(
                            child: Text(body,
                                style: Theme.of(context).textTheme.bodyLarge,
                                overflow: TextOverflow.fade),
                          ),
                          SizedBox(
                            height: 50,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  question.posterAvatarUrl),
                                              radius: 10,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              question.posterName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                            Text(
                                                ' ● ${timeago.format(DateTime.now().subtract(DateTime.now().difference(DateTime.parse(question.createdAt))))}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              question.heart.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Icon(
                                              Icons.comment,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              question.noOfComments.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

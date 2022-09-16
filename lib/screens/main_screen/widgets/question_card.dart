import 'package:badges/badges.dart';
import 'package:cs_mobile/screens/main_screen/models/label.dart';
import 'package:cs_mobile/screens/main_screen/models/question.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:timeago/timeago.dart' as timeago;

class QuestionCard extends StatelessWidget {
  final Question question;
  const QuestionCard({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RegExp exp = RegExp(
      r"!\[]\(.*\)\n",
    );
    String body = question.body.replaceAll(exp, ' *image* ');
    bool isWithImage = question.imageUrl!.isNotEmpty;
    Label label = question.labels.firstWhere(
        (element) => element.name.startsWith('C-'),
        orElse: () => Label(name: 'C-No Category', color: '000000'));
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 0),
      toAnimate: false,
      shape: BadgeShape.square,
      badgeColor: Color(int.parse('FF' + label.color, radix: 16)),
      borderRadius: BorderRadius.circular(8),
      badgeContent: Text(
        label.name.substring(2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(height: isWithImage ? 400 : 200),
          child: Hero(
            tag: 'question' + question.id.toString(),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.go('/questions/q', extra: question),
                child: isWithImage
                    ? _buildCardWithImage(context, body)
                    : _buildCard(context, body),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String body) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Text(
                  ' ● ${timeago.format(DateTime.now().subtract(DateTime.now().difference(DateTime.parse(question.createdAt))))}',
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
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
          Row(
            children: [
              Icon(
                Icons.favorite,
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
    );
  }

  Widget _buildCardWithImage(BuildContext context, String body) {
    return Column(
      children: [
        Expanded(
          child: SizedBox.expand(
              child: Image.network(question.imageUrl!, fit: BoxFit.cover)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
                                    backgroundImage:
                                        NetworkImage(question.posterAvatarUrl),
                                    radius: 10,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    question.posterName,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
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
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
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
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
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
    );
  }
}

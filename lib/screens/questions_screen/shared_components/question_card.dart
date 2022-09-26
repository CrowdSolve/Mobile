import 'package:cs_mobile/models/label.dart';
import 'package:cs_mobile/models/question.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'package:collection/collection.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  const QuestionCard({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String body = _generatePreview(question.body);
    bool isWithImage = question.imageUrl!.isNotEmpty;
    List<Label>? labels = generateLabels();
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: isWithImage ? 400 : 200),
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
        PositionedDirectional(
          top: 0,
          end: 0,
          child: Row(
            children: [
              if(labels != null)
              for ( var label in labels ) CustomBadge(label: label),
            ],
          )
        ),
      ],
    );
  }
  List<Label> generateLabels() {
    List unfilteredLabelList = [];
    List<String> prefixes = ['S', 'C', 'B'];
    for (var prefix in prefixes) {
      unfilteredLabelList.add(question.labels.firstWhereOrNull(
        (element) => element.name.startsWith(prefix + '-'),
      ));
    }

    return unfilteredLabelList.whereType<Label>().toList();
  }
  String _generatePreview(_body) {
    // Remove all images
    _body = _body.replaceAll(RegExp(r"\!\[\]\((.*)\)",),'');
    // Remove all the trailing tags
    int index = _body.indexOf('[tags]:-');
    if (index != -1) {
      _body = _body.substring(0, index);
    }
    // Remove all the trailing spaces
    _body.trim();
    // Clamp to 150 characters
    _body = _body.substring(0, _body.length.clamp(0, 150));

    return _body;
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

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    Key? key,
    required this.label,
  }) : super(key: key);

  final Label label;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(int.parse('FF' + label.color, radix: 16));
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Material(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        color: bgColor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            label.name.substring(2), style: TextStyle(color: bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}

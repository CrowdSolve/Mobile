import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/comment.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  static DateFormat f = DateFormat('MM/dd hh:mm');
  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(comment.posterAvatarUrl),
                      radius: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      comment.posterName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(' ● ${f.format(DateTime.now())}',
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              Expanded(
                child: Text(comment.body,
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
                      comment.heart.toString(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
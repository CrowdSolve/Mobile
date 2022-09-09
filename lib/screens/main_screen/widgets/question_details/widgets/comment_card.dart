import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:timeago/timeago.dart' as timeago;


import '../../../models/comment.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              Text(' ● ${timeago.format(DateTime.now().subtract(DateTime.now().difference(DateTime.parse(comment.createdAt))))}',
                  style: Theme.of(context).textTheme.labelSmall),
              Spacer(),
              firebaseAuth.currentUser!.providerData.first.uid == comment.userId.toString()
                  ? PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Delete'),
                        onTap: () => deleteComment(githubOAuthKeyModel, comment.id),
                      ),
                    ],
                  )
                  : Container(),
            ],
          ),
          SizedBox(
                height: 20,
              ),
          MarkdownBody(
            data: comment.body,
            styleSheet: MarkdownStyleSheet(
              a: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(
                height: 20,
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
                comment.heart.toString(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          )
        ],
      ),
    );
  }
}
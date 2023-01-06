import 'package:cs_mobile/components/md_editor/md_editor.dart';
import 'package:cs_mobile/markdown/markdown_renderer.dart';
import 'package:cs_mobile/models/comment.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:timeago/timeago.dart' as timeago;

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
              InkWell(
                onTap: () => context.go('/users/s',
                    extra: UserModel(
                      login: comment.posterName,
                      avatarUrl: comment.posterAvatarUrl,
                      id: comment.posterName,
                    )),
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
                    Text(
                        ' ● ${timeago.format(DateTime.now().subtract(DateTime.now().difference(DateTime.parse(comment.createdAt))))}',
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              Spacer(),
              if (firebaseAuth.currentUser != null &&
                  firebaseAuth.currentUser!.providerData.first.uid ==
                      comment.userId.toString())
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Delete'),
                      onTap: () =>
                          deleteComment(githubOAuthKeyModel, comment.id),
                    ),
                    PopupMenuItem(
                      child: Text('Edit'),
                      onTap: () => context.push('/comments/${comment.id}/edit',
                          extra: comment),
                    ),
                  ],
                )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          MarkdownRenderer(
            data: comment.body,
            styleSheet: MarkdownStyleSheet(
              a: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

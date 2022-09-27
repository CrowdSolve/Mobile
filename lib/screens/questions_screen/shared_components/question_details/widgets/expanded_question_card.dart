import 'package:cs_mobile/markdown/markdown_renderer.dart';
import 'package:cs_mobile/models/question.dart';
import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';

import 'package:timeago/timeago.dart' as timeago;

class ExpandedQuestionCard extends ConsumerWidget {
  final Question question;

  const ExpandedQuestionCard({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    // TODO: Add the Heros back
    String query = r'''
          query ($number:Int!){
        repository(name:"data", owner:"CrowdSolve") {
          issue(number:$number) {
            reactions {
              viewerHasReacted
              totalCount
            }
          }
      }
    }
    ''';
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox.fromSize(
                  child: IconButton(
                      padding: EdgeInsets.only(right: 5),
                      constraints: BoxConstraints(),
                      onPressed: (() => Navigator.pop(context)),
                      icon: Icon(Icons.arrow_back_ios_rounded)),
                ),
                InkWell(
                  onTap: () => context.go('/users/s',
                      extra: UserModel(
                        login: question.posterName,
                        avatarUrl: question.posterAvatarUrl,
                        id: question.posterName,
                      )),
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
                      Text(
                          ' ● ${timeago.format(DateTime.now().subtract(DateTime.now().difference(DateTime.parse(question.createdAt))))}',
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                )
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
            MarkdownRenderer(
                data: question.body,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(p: Theme.of(context).textTheme.bodyMedium)),
            SizedBox(
              height: 20,
            ),
            Query(
              options: QueryOptions(
                fetchPolicy: FetchPolicy.networkOnly,
                document: gql(query),
                variables: {
                  'number': int.parse(question.id),
                },
              ),
              builder: (QueryResult result,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                Future<bool> onLikeButtonTapped(bool isLiked) async {
                  if (!isLiked)
                    await likeQuestion(
                      githubOAuthKeyModel,
                      question.id,
                    );
                  else
                    await unlikeQuestion(githubOAuthKeyModel, question.id,
                        firebaseAuth.currentUser!.providerData.first.uid!);
                  return !isLiked;
                }

                if (result.hasException) {
                  return Text(result.exception.toString());
                }
                if (result.isLoading) {
                  return Text('Loading');
                }

                bool isLiked = result.data?['repository']?['issue']
                    ?['reactions']?['viewerHasReacted'];
                int totalCount = result.data?['repository']?['issue']
                    ?['reactions']?['totalCount'];
                return Row(
                  children: [
                    LikeButton(
                        isLiked: isLiked,
                        likeCount: totalCount,
                        size: 24,
                        onTap: onLikeButtonTapped),
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
                    Spacer(),
                    IconButton(
                      onPressed: () => Share.share(
                          'https://crowdsolve.lasheen.dev/questions/${question.id}'),
                      icon: Icon(Icons.share),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cs_mobile/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:like_button/like_button.dart';

class GraphqlLikeButton extends ConsumerWidget {
  final int initialCount;
  final String questionId;

  GraphqlLikeButton( {required this.questionId,  required this.initialCount,});
  @override
  Widget build(BuildContext context, ref) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);
    final firebaseAuth = ref.watch(firebaseAuthProvider);
    String questionQuery = r'''
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
    if (firebaseAuth.currentUser == null){
      return Row(
        children: [
          Icon(Icons.favorite),
          SizedBox(width: 5,),
          Text(initialCount.toString()),
        ],
      );

    }
    return GraphQLProvider(
      client: ValueNotifier(
        GraphQLClient(
          link: AuthLink(
            getToken: () => 'Bearer ' + githubOAuthKeyModel,
          ).concat(
            HttpLink(
              'https://api.github.com/graphql',
            ),
          ),
          cache: GraphQLCache(),
        ),
      ),
      child: Query(
        options: QueryOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(questionQuery),
          variables: {
            'number': int.parse(questionId),
          },
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          Future<bool> onLikeButtonTapped(bool isLiked) async {
            if (!isLiked)
              await likeQuestion(githubOAuthKeyModel, questionId);
            else
              await unlikeQuestion(githubOAuthKeyModel, questionId,
                  firebaseAuth.currentUser!.providerData.first.uid!);
            return !isLiked;
          }

          if (result.hasException) {
            return Text(result.exception.toString());
          }

          bool? isLiked = false;
          int? totalCount = initialCount;
          if (result.data != null) {
            isLiked = result.data?['repository']?['issue']?['reactions']
                ?['viewerHasReacted'];
            totalCount = result.data?['repository']?['issue']?['reactions']
                ?['totalCount'];
          }

          return LikeButton(
              isLiked: isLiked,
              likeCount: totalCount,
              size: 24,
              onTap: onLikeButtonTapped);
        },
      ),
    );
  }
}

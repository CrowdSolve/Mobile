import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FullUserInfo extends StatelessWidget {
  final String userLogin;

  FullUserInfo({Key? key, required this.userLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String graph = '''
          query (\$authorQuery: String!, \$involvedQuery: String!, \$mostLikesQuery: String!) {
              authored: search(type: ISSUE, query: \$authorQuery) {
                issueCount
              }
              involved: search(type: ISSUE, query: \$involvedQuery) {
                issueCount
              }
              mostLikes: search(type: ISSUE, query: \$mostLikesQuery, first: 1) {
                edges {
                  node {
                    ... on Issue {
                      reactions {
                        totalCount
                      }
                    }
                  }
                }
              }
              user(login: "$userLogin") {
                bio
                location
                company
                email
                name
                avatarUrl
                id
                websiteUrl
                company,
                login
                
              }
            }
    ''';
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: SizedBox(
        height: 130,
        child: Query(
          options: QueryOptions(
              fetchPolicy: FetchPolicy.cacheAndNetwork,
              document: gql(graph),
              variables: {
                "authorQuery": "author:$userLogin repo:crowdsolve/data",
                "involvedQuery": "involves:$userLogin repo:crowdsolve/data",
                "mostLikesQuery":
                    "author:$userLogin repo:crowdsolve/data, sort:reactions-desc"
              }),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result!.hasException) {
              return Text(result.exception.toString());
            }
            int? authoredCount, involvedCount,mostLikeOnASingleQuestion;
            FullUserModel? user;
            if (result.isNotLoading) {
              var data = result.data!;

               authoredCount = data['authored']?['issueCount'];
               involvedCount = data['involved']?['issueCount'];
               mostLikeOnASingleQuestion = data['mostLikes']?['edges']?[0]
                  ?['node']?['reactions']?['totalCount'];
              //bool isMember = data['organization']?['viewerIsAMember'];
              //bool isAdmin = data['organization']?['viewerCanAdminister'];
              var userData = data['user'];
               user = FullUserModel(
                name: userData?['name'] ?? '',
                email: userData?['email'] ?? '',
                bio: userData?['bio'] ?? '',
                avatarUrl: userData?['avatarUrl'],
                id: userData?['id'],
                location: userData?['location'] ?? '',
                inistitution: userData?['company'] ?? '',
                login: userData?['login'],
                website: userData?['websiteUrl'] ?? '',
              );
            }
            

            return Column(
              children: [
                Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 5),
                          color: Theme.of(context)
                              .colorScheme
                              .shadow
                              .withOpacity(0.5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: user !=null? Text(
                        user.name,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ):CircularProgressIndicator(),
                    )),
                Spacer(),
                if(result.isNotLoading)
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Spacer(),
                      InfoTile(
                          info: authoredCount.toString(), title: 'AUTHORED'),
                      VerticalDivider(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      InfoTile(
                          info: involvedCount.toString(), title: 'ANSWERED'),
                      VerticalDivider(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      InfoTile(
                          info: mostLikeOnASingleQuestion.toString(),
                          title: 'LIKES'),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer()
              ],
            );
          },
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String info;

  const InfoTile({
    Key? key,
    required this.info,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Text(
            info,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            title,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ],
      ),
    );
  }
}

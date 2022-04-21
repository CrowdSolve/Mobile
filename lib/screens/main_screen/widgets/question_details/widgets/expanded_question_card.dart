import 'package:cs_mobile/screens/main_screen/models/question.dart';
import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

class ExpandedQuestionCard extends ConsumerWidget {
  final Question question;
  static DateFormat f = DateFormat('MM/dd hh:mm');

  const ExpandedQuestionCard({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);
    return Hero(
      tag: 'question'+question.id.toString(),
      child: Material(
        color: Theme.of(context).cardColor,
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
              MarkdownBody(data: question.body, styleSheet: MarkdownStyleSheet(a: Theme.of(context).textTheme.bodyLarge)),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  LikeButton(
                    likeCount: question.heart,
                    size: 24,
                    onTap: (liked)  async {
                      if(!liked){
                        bool r = await likeQuestion(githubOAuthKeyModel, question.id);
                        return r; 
                      }else{
                        bool r = await unlikeQuestion(githubOAuthKeyModel, question.id, 102481201);
                        return r;
                      }
                    },
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

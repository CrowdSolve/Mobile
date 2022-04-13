import 'package:cs_mobile/screens/main_screen/models/question.dart';
import 'package:cs_mobile/screens/main_screen/services/questions_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestionDetails extends StatelessWidget {
  final int id;
  static DateFormat f = DateFormat('MM/dd hh:mm');
  const QuestionDetails({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Question>(
      future: fetchWithId(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Question question = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                      Text(' ● ${f.format(DateTime.now())}',
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(question.title,
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
                  ),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return Center(child: const CircularProgressIndicator());
      },
    );
  }
}

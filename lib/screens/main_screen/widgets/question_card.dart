import 'package:cs_mobile/screens/main_screen/models/question.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestionCard extends StatelessWidget {
  static  DateFormat f = DateFormat('MM/dd hh:mm');
  final Question question;
  const QuestionCard({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 200),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          shadowColor: Colors.black54,
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:15.0),
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
                      Text(question.posterName, style: TextStyle(fontSize: 12,color: Colors.black87),),
                      Text(' ● ${f.format(DateTime.now())}',style: TextStyle(fontSize:10,color: Colors.black38)),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(question.title, overflow: TextOverflow.fade),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5,),
                      Text(question.heart.toString(), style: TextStyle(color: Colors.black54),),
                      SizedBox(
                        width: 30,
                      ),
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5,),
                      Text(question.noOfComments.toString(), style: TextStyle(color: Colors.black54),),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

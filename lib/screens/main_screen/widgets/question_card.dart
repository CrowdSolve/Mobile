import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String title;
  const QuestionCard({Key? key, required this.title}) : super(key: key);

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
                      Icon(
                        Icons.circle,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10,),
                      Text('Sam Rewiha', style: TextStyle(fontSize: 12,color: Colors.black87),),
                      Text(' ● 1 hour ago',style: TextStyle(fontSize:10,color: Colors.black38)),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(title, overflow: TextOverflow.fade),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5,),
                      Text('215', style: TextStyle(color: Colors.black54),),
                      SizedBox(
                        width: 30,
                      ),
                      Icon(
                        Icons.comment,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5,),
                      Text('215', style: TextStyle(color: Colors.black54),),

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

import 'package:cs_mobile/models/label.dart';
import 'package:cs_mobile/services/label_service.dart';
import 'package:flutter/material.dart';

class CourseDialog extends StatelessWidget {
  final String institution;

  const CourseDialog({Key? key, required this.institution}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )),
      body: FutureBuilder<List<Label>>(
        future: fetchLabels('I-' + institution),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Set<String> courses = Set();
            for (Label label in snapshot.data!) {
              courses.add(label.name.substring(
                label.name.indexOf(':') + 4,
              ));
            }
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                String label = courses.elementAt(index);
                if (index == 0)
                  return Column(
                    children: [
                      ListTile(
                        title: Text("All Courses"),
                        onTap: () {
                          Navigator.pop(context, "");
                        },
                      ),
                      ListTile(
                        title: Text(label),
                        onTap: () {
                          Navigator.pop(
                              context,
                              label);
                        },
                      )
                    ],
                  );
                return ListTile(
                  title: Text(label),
                  onTap: () {
                    Navigator.pop(context, label);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

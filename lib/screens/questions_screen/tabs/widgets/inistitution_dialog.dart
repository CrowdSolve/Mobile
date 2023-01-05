import 'package:cs_mobile/models/label.dart';
import 'package:cs_mobile/services/label_service.dart';
import 'package:flutter/material.dart';

class InistitutionDialog extends StatelessWidget {
  final String course;

  const InistitutionDialog({Key? key, required this.course}) : super(key: key);
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
        future: fetchLabels('C-' + course),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Set<String> institutions = Set();
            for (Label label in snapshot.data!) {
              institutions
                  .add(label.name.substring(2, label.name.indexOf(':') - 1));
            }
            return ListView.builder(
              itemCount: institutions.length,
              itemBuilder: (context, index) {
                String label = institutions.elementAt(index);
                if (index == 0)
                  return Column(
                    children: [
                      ListTile(
                        title: Text("All Institutions"),
                        onTap: () {
                          Navigator.pop(context, "");
                        },
                      ),
                      ListTile(
                        title: Text(label),
                        onTap: () {
                          Navigator.pop(context, label);
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

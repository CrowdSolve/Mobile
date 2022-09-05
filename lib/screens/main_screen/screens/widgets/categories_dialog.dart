import 'package:cs_mobile/screens/main_screen/models/label.dart';
import 'package:cs_mobile/screens/main_screen/services/label_service.dart';
import 'package:flutter/material.dart';

class CategoriesDialog extends StatelessWidget {
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
  future: fetchLabels(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                if (index == 0)
                  return Column(
                    children: [
                      ListTile(
                        title: Text("All Categories"),
                        onTap: () {
                          Navigator.pop(context,"");
                        },
                      ),
                      ListTile(
                        title: Text(snapshot.data![index].name.substring(2)),
                        onTap: () {
                          Navigator.pop(context,snapshot.data![index].name);
                        },
                      )
                    ],
                  );
                return ListTile(
                  title: Text(snapshot.data![index].name.substring(2)),
                  onTap: () {
                    Navigator.pop(context,snapshot.data![index].name);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }

    // By default, show a loading spinner.
    return const CircularProgressIndicator();
  },
),
    );
  }
}

import 'package:cs_mobile/screens/main_screen/search/search_delegate.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        showSearch(context: context, delegate: Search());
      },
      icon: Icon(Icons.search),
      label: Text("search"),
    );
  }
}

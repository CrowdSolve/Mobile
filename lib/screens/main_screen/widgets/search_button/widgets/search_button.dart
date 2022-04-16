import 'package:cs_mobile/screens/main_screen/search/search_delegate.dart';
import 'package:cs_mobile/screens/main_screen/widgets/search_button/widgets/auth_avatar_button.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {
          showSearch(context: context, delegate: Search());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 30,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Search',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ),
            AuthAvatarButton()
          ],
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

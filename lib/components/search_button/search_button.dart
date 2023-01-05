import 'package:cs_mobile/search/search_delegate.dart';
import 'package:cs_mobile/components/search_button/widgets/auth_avatar_button.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchButton extends ConsumerWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);
    final signedIn = ref.watch(firebaseAuthProvider).currentUser != null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {
          showSearch(context: context, delegate: Search());
        },
        child: SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Search',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                  ),
                ),
              ),
              signedIn?
              AuthAvatarButton(githubOAuthKeyModel: githubOAuthKeyModel,):ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

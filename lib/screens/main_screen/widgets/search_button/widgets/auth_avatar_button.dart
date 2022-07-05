import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/screens/main_screen/widgets/search_button/widgets/profile_dialog.dart';
import 'package:cs_mobile/services/user_service.dart';
import 'package:cs_mobile/top_level_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthAvatarButton extends ConsumerWidget {
  const AuthAvatarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final githubOAuthKeyModel = ref.watch(githubOAuthKeyModelProvider);
    return FutureBuilder<UserModel>(
      future: fetchAuthenticatedUser(githubOAuthKeyModel),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  barrierDismissible: true,
                  pageBuilder: (_, anim, ___) => FadeTransition(
                    opacity: anim,
                    child: ProfileDialog(
                      user: snapshot.data!,
                    ),
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Hero(
                tag: 'avatar',
                child: CircleAvatar(
                  maxRadius: 15,
                  backgroundImage: NetworkImage(snapshot.data!.avatarUrl,),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Icon(Icons.error_outline_rounded, color: Colors.red,);
        }

        // By default, show a loading spinner.
        return const AspectRatio(
          aspectRatio: 1,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}

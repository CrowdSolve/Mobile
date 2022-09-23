import 'package:cs_mobile/models/user.dart';
import 'package:cs_mobile/services/user_service.dart';
import 'package:flutter/material.dart';

class FullUserInfo extends StatefulWidget {
  final String userId;

  const FullUserInfo({Key? key, required this.userId}) : super(key: key);

  @override
  State<FullUserInfo> createState() => _FullUserInfoState();
}

class _FullUserInfoState extends State<FullUserInfo> {
  late Future<FullUserModel> fullUser;
  @override
  void initState() {
    fullUser = fetchUserWithId(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: SizedBox(
        height: 130,
        child: FutureBuilder<FullUserModel>(
          future: fullUser,
          builder: (context, snapshot) {
            FullUserModel? user= snapshot.data; 
            return Column(
              children: [
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withOpacity(0.5),
                    ),
                  ],
                ),
                child: user != null? Center(
                  child: Text(
                    user.name,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ):SizedBox.shrink(),
              ),
              Spacer(),
              if (user != null)
                Row(
                  children: [
                    if (user.email.isNotEmpty)
                      InfoTile(info: user.email, icon: Icons.email_rounded),
                    SizedBox(
                      width: 20,
                    ),
                    if (user.location.isNotEmpty)
                      InfoTile(
                          info: user.location,
                          icon: Icons.location_on_rounded),
                    SizedBox(
                      width: 20,
                    ),
                    if (user.bio.isNotEmpty)
                      InfoTile(info: user.bio, icon: Icons.article_rounded),
                  ],
                )
              else
                const Center(child: CircularProgressIndicator())

              ,Spacer()
            ]);
          },
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String info;
  final IconData icon;

  const InfoTile({Key? key, required this.info, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSecondaryContainer,),
          Text(info,style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),),
        ],
      ),
    );
  }
}

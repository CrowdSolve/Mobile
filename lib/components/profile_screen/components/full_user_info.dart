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
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 5),
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
                )
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Center(
              child: FutureBuilder<FullUserModel>(
                future: fullUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    FullUserModel user = snapshot.data!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (user.email.isNotEmpty)
                          InfoTile(info: user.email, icon: Icons.email_rounded),
                        SizedBox(
                          width: 20,
                        ),
                        if (user.name.isNotEmpty)
                          InfoTile(info: user.name, icon: Icons.person),
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
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox.shrink();
                  }

                  // By default, show a loading spinner.
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
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
    return Column(
      children: [
        Icon(icon),
        Text(info),
      ],
    );
  }
}

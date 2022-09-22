class UserModel {
  final String id;
  final String login;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.login,
    required this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"].toString(),
      login: json["login"],
      avatarUrl: json["avatar_url"],
    );
  }
}

class FullUserModel extends UserModel {
  final String name;
  final String bio;
  final String website;
  final String email;
  final String inistitution;
  final String location;

  FullUserModel(
      {required this.name,
      required this.bio,
      required this.website,
      required this.email,
      required this.inistitution,
      required this.location,
      required String id,
      required String login,
      required String avatarUrl})
      : super(id: id, login: login, avatarUrl: avatarUrl);

  factory FullUserModel.fromJson(Map<String, dynamic> json) {
    return FullUserModel(
      id: json["id"].toString(),
      login: json["login"],
      avatarUrl: json["avatar_url"],
      name: json["name"]??"",
      bio: json["bio"]??"",
      website: json["blog"]??"",
      email: json["email"]??"",
      inistitution: json["company"]??"",
      location: json["location"]??"",
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String login;
  final String avatarUrl;



  const UserModel({
    required this.id,
    required this.name,
    required this.login,
    required this.avatarUrl,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      login: json["login"],
      name: json["name"]??"",
      avatarUrl: json["avatar_url"],
    );
  }
}

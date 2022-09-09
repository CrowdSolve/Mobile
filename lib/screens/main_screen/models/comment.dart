class Comment {
  final int id;
  final int userId;
  final String body;
  final String posterAvatarUrl;
  final String posterName;
  final String createdAt;
  final int heart;

  const Comment({
    required this.id,
    required this.userId,
    required this.body,
    required this.posterName,
    required this.posterAvatarUrl,
    required this.createdAt,
    required this.heart,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      userId: json["user"]["id"],
      body: json["body"],
      posterName: json["user"]["login"],
      posterAvatarUrl: json["user"]["avatar_url"],
      createdAt: json["created_at"],
      heart: json["reactions"]['heart'],
    );
  }
}

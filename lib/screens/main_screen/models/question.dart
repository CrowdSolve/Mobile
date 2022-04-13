class Question {
  final int id;
  final String title;
  final String posterAvatarUrl;
  final String posterName;
  final String createdAt;
  final int heart;
  final int noOfComments;

  const Question({
    required this.id,
    required this.title,
    required this.posterName,
    required this.posterAvatarUrl,
    required this.createdAt,
    required this.heart,
    required this.noOfComments,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json["number"],
      title: json["title"],
      posterName: json["user"]["login"],
      posterAvatarUrl: json["user"]["avatar_url"],
      createdAt: json["created_at"],
      heart: json["reactions"]['heart'],
      noOfComments: json["comments"],
    );
  }
}

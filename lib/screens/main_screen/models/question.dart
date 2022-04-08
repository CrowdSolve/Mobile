class Questions {
  final List<Question> questions;

  const Questions({
    required this.questions,
  });

  factory Questions.fromJson(List json) {
    return Questions(
      questions: (json as List).map((i) => Question.fromJson(i)).toList(),
    );
  }
}

class Question {
  final String title;
  final String posterAvatarUrl;
  final String posterName;
  final String createdAt;
  final int heart;
  final int noOfComments;

  const Question({
    required this.title,
    required this.posterName,
    required this.posterAvatarUrl,
    required this.createdAt,
    required this.heart,
    required this.noOfComments,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      title: json["title"],
      posterName: json["user"]["login"],
      posterAvatarUrl: json["user"]["avatar_url"],
      createdAt: json["created_at"],
      heart: json["reactions"]['heart'],
      noOfComments: json["comments"],
    );
  }
}

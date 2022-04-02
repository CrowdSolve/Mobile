



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
  final String userId;

  const Question({
    required this.userId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      userId: json["title"],
    );
  }
}

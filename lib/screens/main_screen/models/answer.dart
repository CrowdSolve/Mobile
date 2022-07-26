class Answer {
  final String title;

  const Answer({
    required this.title,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      title: json["subject"]["title"],
    );
  }
}

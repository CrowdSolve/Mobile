class Question {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final String posterAvatarUrl;
  final String posterName;
  final String createdAt;
  final int heart;
  final int noOfComments;

  const Question({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.posterName,
    required this.posterAvatarUrl,
    required this.createdAt,
    required this.heart,
    required this.noOfComments,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    RegExp exp = RegExp(r'\!\[\]\((.*)\)');
    RegExpMatch? firstMatch = exp.firstMatch(json["body"]??"");
    String url = '';
    if (firstMatch!=null) url=firstMatch.group(1)!;

    return Question(
      id: json["number"],
      title: json["title"],
      body: json["body"]??"",
      imageUrl:  url,
      posterName: json["user"]["login"],
      posterAvatarUrl: json["user"]["avatar_url"],
      createdAt: json["created_at"],
      heart: json["reactions"]['heart'],
      noOfComments: json["comments"],
    );
  }
}

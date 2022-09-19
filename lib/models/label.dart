class Label {
  final String name;
  final String color;

  const Label({
    required this.name,
    required this.color,
  });

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      name: json["name"],
      color: json["color"],
    );
  }
}

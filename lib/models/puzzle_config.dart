class PuzzleConfig {
  final String id;
  final String title;
  final String imageUrl;
  final String description;

  const PuzzleConfig({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  factory PuzzleConfig.fromJson(Map<String, dynamic> json) {
    return PuzzleConfig(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PuzzleConfig &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

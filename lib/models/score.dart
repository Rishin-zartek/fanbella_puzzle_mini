class Score {
  final String id;
  final String puzzleId;
  final String puzzleTitle;
  final int level;
  final int score;
  final int moves;
  final int timeSeconds;
  final DateTime completedAt;

  const Score({
    required this.id,
    required this.puzzleId,
    required this.puzzleTitle,
    required this.level,
    required this.score,
    required this.moves,
    required this.timeSeconds,
    required this.completedAt,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      id: json['id'] as String,
      puzzleId: json['puzzleId'] as String,
      puzzleTitle: json['puzzleTitle'] as String,
      level: json['level'] as int,
      score: json['score'] as int,
      moves: json['moves'] as int,
      timeSeconds: json['timeSeconds'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'puzzleId': puzzleId,
      'puzzleTitle': puzzleTitle,
      'level': level,
      'score': score,
      'moves': moves,
      'timeSeconds': timeSeconds,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  String get formattedTime {
    final minutes = timeSeconds ~/ 60;
    final seconds = timeSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Score && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class LeaderboardEntry {
  final String scoreId;
  final String puzzleTitle;
  final int level;
  final int score;
  final int moves;
  final int timeSeconds;
  final DateTime completedAt;
  final int rank;

  const LeaderboardEntry({
    required this.scoreId,
    required this.puzzleTitle,
    required this.level,
    required this.score,
    required this.moves,
    required this.timeSeconds,
    required this.completedAt,
    this.rank = 0,
  });

  factory LeaderboardEntry.fromScore(Score score, {int rank = 0}) {
    return LeaderboardEntry(
      scoreId: score.id,
      puzzleTitle: score.puzzleTitle,
      level: score.level,
      score: score.score,
      moves: score.moves,
      timeSeconds: score.timeSeconds,
      completedAt: score.completedAt,
      rank: rank,
    );
  }

  String get formattedTime {
    final minutes = timeSeconds ~/ 60;
    final seconds = timeSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get difficultyLabel {
    switch (level) {
      case 3:
        return 'Easy';
      case 4:
        return 'Medium';
      case 5:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }

  LeaderboardEntry copyWith({int? rank}) {
    return LeaderboardEntry(
      scoreId: scoreId,
      puzzleTitle: puzzleTitle,
      level: level,
      score: score,
      moves: moves,
      timeSeconds: timeSeconds,
      completedAt: completedAt,
      rank: rank ?? this.rank,
    );
  }
}

// Import Score model
import 'score.dart';

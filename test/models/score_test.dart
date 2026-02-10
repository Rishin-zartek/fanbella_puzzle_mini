import 'package:flutter_test/flutter_test.dart';
import 'package:movie_puzzle_game/models/score.dart';

void main() {
  group('Score', () {
    final testDate = DateTime(2024, 1, 15, 10, 30);

    test('creates score with all properties', () {
      final score = Score(
        id: 'test-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 120,
        completedAt: testDate,
      );

      expect(score.id, 'test-id');
      expect(score.puzzleId, 'puzzle-1');
      expect(score.puzzleTitle, 'Test Puzzle');
      expect(score.level, 3);
      expect(score.score, 1000);
      expect(score.moves, 50);
      expect(score.timeSeconds, 120);
      expect(score.completedAt, testDate);
    });

    test('toJson converts score to map', () {
      final score = Score(
        id: 'test-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 120,
        completedAt: testDate,
      );

      final json = score.toJson();

      expect(json['id'], 'test-id');
      expect(json['puzzleId'], 'puzzle-1');
      expect(json['puzzleTitle'], 'Test Puzzle');
      expect(json['level'], 3);
      expect(json['score'], 1000);
      expect(json['moves'], 50);
      expect(json['timeSeconds'], 120);
      expect(json['completedAt'], testDate.toIso8601String());
    });

    test('fromJson creates score from map', () {
      final json = {
        'id': 'test-id',
        'puzzleId': 'puzzle-1',
        'puzzleTitle': 'Test Puzzle',
        'level': 3,
        'score': 1000,
        'moves': 50,
        'timeSeconds': 120,
        'completedAt': testDate.toIso8601String(),
      };

      final score = Score.fromJson(json);

      expect(score.id, 'test-id');
      expect(score.puzzleId, 'puzzle-1');
      expect(score.puzzleTitle, 'Test Puzzle');
      expect(score.level, 3);
      expect(score.score, 1000);
      expect(score.moves, 50);
      expect(score.timeSeconds, 120);
      expect(score.completedAt, testDate);
    });

    test('formattedTime formats seconds correctly', () {
      final score1 = Score(
        id: 'test-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 65,
        completedAt: testDate,
      );

      expect(score1.formattedTime, '01:05');

      final score2 = Score(
        id: 'test-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 125,
        completedAt: testDate,
      );

      expect(score2.formattedTime, '02:05');

      final score3 = Score(
        id: 'test-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 5,
        completedAt: testDate,
      );

      expect(score3.formattedTime, '00:05');
    });

    test('equality works correctly', () {
      final score1 = Score(
        id: 'test-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 120,
        completedAt: testDate,
      );

      final score2 = Score(
        id: 'test-id',
        puzzleId: 'puzzle-2',
        puzzleTitle: 'Different Puzzle',
        level: 4,
        score: 2000,
        moves: 100,
        timeSeconds: 240,
        completedAt: testDate,
      );

      final score3 = Score(
        id: 'different-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 120,
        completedAt: testDate,
      );

      expect(score1 == score2, true);
      expect(score1 == score3, false);
    });

    test('hashCode is based on id', () {
      final score1 = Score(
        id: 'test-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 120,
        completedAt: testDate,
      );

      final score2 = Score(
        id: 'test-id',
        puzzleId: 'puzzle-2',
        puzzleTitle: 'Different Puzzle',
        level: 4,
        score: 2000,
        moves: 100,
        timeSeconds: 240,
        completedAt: testDate,
      );

      expect(score1.hashCode, score2.hashCode);
    });

    test('json serialization round trip', () {
      final originalScore = Score(
        id: 'test-id',
        puzzleId: 'puzzle-1',
        puzzleTitle: 'Test Puzzle',
        level: 3,
        score: 1000,
        moves: 50,
        timeSeconds: 120,
        completedAt: testDate,
      );

      final json = originalScore.toJson();
      final deserializedScore = Score.fromJson(json);

      expect(deserializedScore.id, originalScore.id);
      expect(deserializedScore.puzzleId, originalScore.puzzleId);
      expect(deserializedScore.puzzleTitle, originalScore.puzzleTitle);
      expect(deserializedScore.level, originalScore.level);
      expect(deserializedScore.score, originalScore.score);
      expect(deserializedScore.moves, originalScore.moves);
      expect(deserializedScore.timeSeconds, originalScore.timeSeconds);
      expect(deserializedScore.completedAt, originalScore.completedAt);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_puzzle_game/providers/game_provider.dart';
import 'package:movie_puzzle_game/models/puzzle_config.dart';
import 'package:movie_puzzle_game/core/constants/app_constants.dart';

void main() {
  group('GameState', () {
    test('creates game state with required properties', () {
      final puzzle = PuzzleConfig(
        description: 'Test puzzle description',
        id: 'test-puzzle',
        title: 'Test Puzzle',
        imageUrl: 'https://example.com/image.jpg',
      );

      final state = GameState(
        tiles: [],
        moves: 0,
        timeSeconds: 0,
        isLoading: true,
        isCompleted: false,
        difficulty: DifficultyLevel.easy,
        puzzle: puzzle,
      );

      expect(state.tiles, isEmpty);
      expect(state.moves, 0);
      expect(state.timeSeconds, 0);
      expect(state.isLoading, true);
      expect(state.isCompleted, false);
      expect(state.difficulty, DifficultyLevel.easy);
      expect(state.puzzle, puzzle);
      expect(state.error, isNull);
    });

    test('copyWith creates new state with updated properties', () {
      final puzzle = PuzzleConfig(
        description: 'Test puzzle description',
        id: 'test-puzzle',
        title: 'Test Puzzle',
        imageUrl: 'https://example.com/image.jpg',
      );

      final state = GameState(
        tiles: [],
        moves: 0,
        timeSeconds: 0,
        isLoading: true,
        isCompleted: false,
        difficulty: DifficultyLevel.easy,
        puzzle: puzzle,
      );

      final updatedState = state.copyWith(
        moves: 5,
        timeSeconds: 30,
        isLoading: false,
      );

      expect(updatedState.moves, 5);
      expect(updatedState.timeSeconds, 30);
      expect(updatedState.isLoading, false);
      expect(updatedState.tiles, state.tiles);
      expect(updatedState.difficulty, state.difficulty);
    });

    test('finalScore calculates correctly for easy difficulty', () {
      final puzzle = PuzzleConfig(
        description: 'Test puzzle description',
        id: 'test-puzzle',
        title: 'Test Puzzle',
        imageUrl: 'https://example.com/image.jpg',
      );

      final state = GameState(
        tiles: [],
        moves: 10,
        timeSeconds: 0,
        isLoading: false,
        isCompleted: false,
        difficulty: DifficultyLevel.easy,
        puzzle: puzzle,
      );

      final expectedScore = DifficultyLevel.easy.startingPoints - 
                           (10 * DifficultyLevel.easy.pointsPerMove);
      expect(state.finalScore, expectedScore);
    });

    test('finalScore calculates correctly for medium difficulty', () {
      final puzzle = PuzzleConfig(
        description: 'Test puzzle description',
        id: 'test-puzzle',
        title: 'Test Puzzle',
        imageUrl: 'https://example.com/image.jpg',
      );

      final state = GameState(
        tiles: [],
        moves: 20,
        timeSeconds: 0,
        isLoading: false,
        isCompleted: false,
        difficulty: DifficultyLevel.medium,
        puzzle: puzzle,
      );

      final expectedScore = DifficultyLevel.medium.startingPoints - 
                           (20 * DifficultyLevel.medium.pointsPerMove);
      expect(state.finalScore, expectedScore);
    });

    test('finalScore calculates correctly for hard difficulty', () {
      final puzzle = PuzzleConfig(
        description: 'Test puzzle description',
        id: 'test-puzzle',
        title: 'Test Puzzle',
        imageUrl: 'https://example.com/image.jpg',
      );

      final state = GameState(
        tiles: [],
        moves: 30,
        timeSeconds: 0,
        isLoading: false,
        isCompleted: false,
        difficulty: DifficultyLevel.hard,
        puzzle: puzzle,
      );

      final expectedScore = DifficultyLevel.hard.startingPoints - 
                           (30 * DifficultyLevel.hard.pointsPerMove);
      expect(state.finalScore, expectedScore);
    });

    test('finalScore returns 0 when score would be negative', () {
      final puzzle = PuzzleConfig(
        description: 'Test puzzle description',
        id: 'test-puzzle',
        title: 'Test Puzzle',
        imageUrl: 'https://example.com/image.jpg',
      );

      final state = GameState(
        tiles: [],
        moves: 1000,
        timeSeconds: 0,
        isLoading: false,
        isCompleted: false,
        difficulty: DifficultyLevel.easy,
        puzzle: puzzle,
      );

      expect(state.finalScore, 0);
    });

    test('finalScore with zero moves returns starting points', () {
      final puzzle = PuzzleConfig(
        description: 'Test puzzle description',
        id: 'test-puzzle',
        title: 'Test Puzzle',
        imageUrl: 'https://example.com/image.jpg',
      );

      final state = GameState(
        tiles: [],
        moves: 0,
        timeSeconds: 0,
        isLoading: false,
        isCompleted: false,
        difficulty: DifficultyLevel.easy,
        puzzle: puzzle,
      );

      expect(state.finalScore, DifficultyLevel.easy.startingPoints);
    });

    test('finalScore decreases with more moves', () {
      final puzzle = PuzzleConfig(
        description: 'Test puzzle description',
        id: 'test-puzzle',
        title: 'Test Puzzle',
        imageUrl: 'https://example.com/image.jpg',
      );

      final state1 = GameState(
        tiles: [],
        moves: 10,
        timeSeconds: 0,
        isLoading: false,
        isCompleted: false,
        difficulty: DifficultyLevel.easy,
        puzzle: puzzle,
      );

      final state2 = GameState(
        tiles: [],
        moves: 20,
        timeSeconds: 0,
        isLoading: false,
        isCompleted: false,
        difficulty: DifficultyLevel.easy,
        puzzle: puzzle,
      );

      expect(state2.finalScore, lessThan(state1.finalScore));
    });
  });
}

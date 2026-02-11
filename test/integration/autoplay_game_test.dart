import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_puzzle_game/services/image_service.dart';
import 'package:movie_puzzle_game/services/puzzle_solver.dart';
import 'package:movie_puzzle_game/core/constants/puzzle_data.dart';
import 'package:movie_puzzle_game/core/constants/app_constants.dart';
import 'package:movie_puzzle_game/providers/game_provider.dart';
import 'package:movie_puzzle_game/models/puzzle_config.dart';
import 'package:movie_puzzle_game/models/tile.dart';
import 'package:image/image.dart' as img;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Automated Gameplay Integration Tests', () {
    late ImageService imageService;
    late PuzzleSolver solver;

    setUp(() {
      imageService = ImageService();
      solver = PuzzleSolver();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    void setupMockAssets() {
      final testImages = <String, Uint8List>{};
      for (var puzzle in PuzzleData.moviePuzzles) {
        final testImage = img.Image(width: 300, height: 300);
        img.fill(testImage, color: img.ColorRgb8(255, 0, 0));
        testImages[puzzle['imageUrl']!] = Uint8List.fromList(img.encodePng(testImage));
      }

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final String key = utf8.decode(message!.buffer.asUint8List());
        if (testImages.containsKey(key)) {
          return ByteData.view(testImages[key]!.buffer);
        }
        return null;
      });
    }

    test('autoplay easy puzzle (3x3) from start to finish', () async {
      setupMockAssets();

      final puzzle = PuzzleConfig(
        id: 'puzzle_1',
        title: 'Classic Cinema',
        imageUrl: 'assets/images/puzzle_1.jpg',
        description: 'Vintage movie theater',
      );

      final imageData = await imageService.loadImageFromAssets(puzzle.imageUrl);
      expect(imageData, isNotNull);

      final tiles = await imageService.splitImageIntoTiles(imageData, 3);
      expect(tiles.length, 9);

      final shuffledTiles = imageService.shuffleTiles(tiles, 3);
      
      if (!imageService.isPuzzleSolved(shuffledTiles)) {
        final moves = solver.solvePuzzle(shuffledTiles, 3);
        expect(moves, isNotEmpty, reason: 'Solver should produce moves');
        expect(moves.length, lessThan(10000), reason: 'Solution should be reasonable');
        
        for (var i = 0; i < moves.length.clamp(0, 10); i++) {
          final moveIndex = moves[i];
          expect(moveIndex, greaterThanOrEqualTo(0));
          expect(moveIndex, lessThan(9));
        }
      }
    });

    test('autoplay medium puzzle (4x4) from start to finish', () async {
      setupMockAssets();

      final puzzle = PuzzleConfig(
        id: 'puzzle_2',
        title: 'Movie Projector',
        imageUrl: 'assets/images/puzzle_2.jpg',
        description: 'Vintage projector',
      );

      final imageData = await imageService.loadImageFromAssets(puzzle.imageUrl);
      final tiles = await imageService.splitImageIntoTiles(imageData, 4);
      expect(tiles.length, 16);

      final shuffledTiles = imageService.shuffleTiles(tiles, 4);
      
      if (!imageService.isPuzzleSolved(shuffledTiles)) {
        final moves = solver.solvePuzzle(shuffledTiles, 4);
        expect(moves, isNotEmpty);
        expect(moves.length, lessThan(20000));
      }
    });

    test('autoplay hard puzzle (5x5) from start to finish', () async {
      setupMockAssets();

      final puzzle = PuzzleConfig(
        id: 'puzzle_3',
        title: 'Clapperboard',
        imageUrl: 'assets/images/puzzle_3.jpg',
        description: 'Movie clapperboard scene',
      );

      final imageData = await imageService.loadImageFromAssets(puzzle.imageUrl);
      final tiles = await imageService.splitImageIntoTiles(imageData, 5);
      expect(tiles.length, 25);

      final shuffledTiles = imageService.shuffleTiles(tiles, 5);
      
      if (!imageService.isPuzzleSolved(shuffledTiles)) {
        final moves = solver.solvePuzzle(shuffledTiles, 5);
        expect(moves, isNotEmpty);
        expect(moves.length, lessThan(50000));
      }
    });

    test('autoplay all puzzles at easy difficulty', () async {
      setupMockAssets();

      for (var puzzleData in PuzzleData.moviePuzzles) {
        final puzzle = PuzzleConfig(
          id: puzzleData['id']!,
          title: puzzleData['title']!,
          imageUrl: puzzleData['imageUrl']!,
          description: puzzleData['description']!,
        );

        final imageData = await imageService.loadImageFromAssets(puzzle.imageUrl);
        final tiles = await imageService.splitImageIntoTiles(imageData, 3);
        final shuffledTiles = imageService.shuffleTiles(tiles, 3);
        
        if (!imageService.isPuzzleSolved(shuffledTiles)) {
          final moves = solver.solvePuzzle(shuffledTiles, 3);
          expect(moves, isNotEmpty, reason: 'Puzzle ${puzzle.title} should have solution');
          expect(moves.length, lessThan(10000), reason: 'Solution should be reasonable length');
        }
      }
    });

    test('game provider integration with solver', () async {
      setupMockAssets();

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final puzzle = PuzzleConfig(
        id: 'puzzle_1',
        title: 'Classic Cinema',
        imageUrl: 'assets/images/puzzle_1.jpg',
        description: 'Vintage movie theater',
      );

      final params = GameParams(
        puzzle: puzzle,
        difficulty: DifficultyLevel.easy,
      );

      final subscription = container.listen(gameProvider(params), (_, __) {});
      addTearDown(subscription.close);

      await Future.delayed(const Duration(milliseconds: 200));

      final state = container.read(gameProvider(params));
      expect(state.isLoading, false);
      expect(state.error, null);
      expect(state.tiles, isNotEmpty);

      if (!imageService.isPuzzleSolved(state.tiles)) {
        final moves = solver.solvePuzzle(state.tiles, 3);
        expect(moves, isNotEmpty);
        
        final notifier = container.read(gameProvider(params).notifier);
        for (final moveIndex in moves.take(3)) {
          notifier.moveTile(moveIndex);
        }

        final updatedState = container.read(gameProvider(params));
        expect(updatedState.moves, greaterThan(0));
      }
    });

    test('score calculation during autoplay', () async {
      setupMockAssets();

      final puzzle = PuzzleConfig(
        id: 'puzzle_1',
        title: 'Classic Cinema',
        imageUrl: 'assets/images/puzzle_1.jpg',
        description: 'Vintage movie theater',
      );

      final imageData = await imageService.loadImageFromAssets(puzzle.imageUrl);
      final tiles = await imageService.splitImageIntoTiles(imageData, 3);
      final shuffledTiles = imageService.shuffleTiles(tiles, 3);
      
      if (!imageService.isPuzzleSolved(shuffledTiles)) {
        final moves = solver.solvePuzzle(shuffledTiles, 3);
        
        final startingPoints = DifficultyLevel.easy.startingPoints;
        final pointsPerMove = DifficultyLevel.easy.pointsPerMove;
        final expectedScore = startingPoints - (moves.length * pointsPerMove);
        final finalScore = expectedScore < 0 ? 0 : expectedScore;
        
        expect(finalScore, greaterThanOrEqualTo(0));
        expect(finalScore, lessThanOrEqualTo(startingPoints));
      }
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_puzzle_game/services/puzzle_solver.dart';
import 'package:movie_puzzle_game/services/image_service.dart';
import 'package:movie_puzzle_game/models/tile.dart';

void main() {
  group('PuzzleSolver Tests', () {
    late PuzzleSolver solver;
    late ImageService imageService;

    setUp(() {
      solver = PuzzleSolver();
      imageService = ImageService();
    });

    test('returns empty list for already solved puzzle', () {
      final tiles = [
        Tile(index: 0, currentPosition: 0, correctPosition: 0),
        Tile(index: 1, currentPosition: 1, correctPosition: 1),
        Tile(index: 2, currentPosition: 2, correctPosition: 2),
        Tile(index: 3, currentPosition: 3, correctPosition: 3, isEmpty: true),
      ];

      final moves = solver.solvePuzzle(tiles, 2);
      expect(moves, isEmpty);
    });

    test('solves simple 2x2 puzzle with one move', () {
      final tiles = [
        Tile(index: 0, currentPosition: 0, correctPosition: 0),
        Tile(index: 1, currentPosition: 1, correctPosition: 1),
        Tile(index: 2, currentPosition: 3, correctPosition: 2),
        Tile(index: 3, currentPosition: 2, correctPosition: 3, isEmpty: true),
      ];

      final moves = solver.solvePuzzle(tiles, 2);
      expect(moves, isNotEmpty);
      
      var currentTiles = List<Tile>.from(tiles);
      for (final moveIndex in moves) {
        final emptyTile = currentTiles.firstWhere((t) => t.isEmpty);
        final tileToMove = currentTiles[moveIndex];
        
        final emptyIdx = currentTiles.indexOf(emptyTile);
        final moveIdx = currentTiles.indexOf(tileToMove);
        
        final tempPos = currentTiles[emptyIdx].currentPosition;
        currentTiles[emptyIdx] = currentTiles[emptyIdx].copyWith(
          currentPosition: currentTiles[moveIdx].currentPosition,
        );
        currentTiles[moveIdx] = currentTiles[moveIdx].copyWith(
          currentPosition: tempPos,
        );
      }
      
      expect(imageService.isPuzzleSolved(currentTiles), true);
    });

    test('solves 3x3 puzzle', () {
      final tiles = [
        Tile(index: 0, currentPosition: 1, correctPosition: 0),
        Tile(index: 1, currentPosition: 0, correctPosition: 1),
        Tile(index: 2, currentPosition: 2, correctPosition: 2),
        Tile(index: 3, currentPosition: 3, correctPosition: 3),
        Tile(index: 4, currentPosition: 4, correctPosition: 4),
        Tile(index: 5, currentPosition: 5, correctPosition: 5),
        Tile(index: 6, currentPosition: 6, correctPosition: 6),
        Tile(index: 7, currentPosition: 7, correctPosition: 7),
        Tile(index: 8, currentPosition: 8, correctPosition: 8, isEmpty: true),
      ];

      final moves = solver.solvePuzzle(tiles, 3);
      expect(moves, isNotEmpty);
      expect(moves.length, lessThan(1000));
    });

    test('can solve shuffled puzzle', () {
      final tiles = [
        Tile(index: 0, currentPosition: 0, correctPosition: 0),
        Tile(index: 1, currentPosition: 1, correctPosition: 1),
        Tile(index: 2, currentPosition: 2, correctPosition: 2),
        Tile(index: 3, currentPosition: 3, correctPosition: 3),
        Tile(index: 4, currentPosition: 4, correctPosition: 4),
        Tile(index: 5, currentPosition: 5, correctPosition: 5),
        Tile(index: 6, currentPosition: 6, correctPosition: 6),
        Tile(index: 7, currentPosition: 7, correctPosition: 7),
        Tile(index: 8, currentPosition: 8, correctPosition: 8, isEmpty: true),
      ];

      final shuffledTiles = imageService.shuffleTiles(tiles, 3);
      
      if (!imageService.isPuzzleSolved(shuffledTiles)) {
        final moves = solver.solvePuzzle(shuffledTiles, 3);
        expect(moves, isNotEmpty);
        expect(moves.length, lessThan(10000));
      }
    });
  });
}

import '../models/tile.dart';
import 'dart:math';

class PuzzleSolver {
  final Random _random = Random();

  List<int> solvePuzzle(List<Tile> tiles, int gridSize) {
    if (_isSolved(tiles)) {
      return [];
    }

    return _getGreedySolution(tiles, gridSize);
  }

  List<int> _getGreedySolution(List<Tile> tiles, int gridSize) {
    final moves = <int>[];
    var currentTiles = List<Tile>.from(tiles);
    int maxMoves = gridSize * gridSize * 100;
    int stuckCounter = 0;
    int lastScore = _calculateScore(currentTiles, gridSize);

    while (!_isSolved(currentTiles) && moves.length < maxMoves) {
      final emptyTile = currentTiles.firstWhere((t) => t.isEmpty);
      final possibleMoves = _getPossibleMoves(emptyTile.currentPosition, gridSize);

      int? bestMove;
      int bestScore = -999999;

      for (final movePos in possibleMoves) {
        final tileToMove = currentTiles.firstWhere((t) => t.currentPosition == movePos);
        final newTiles = _moveTile(currentTiles, tileToMove.index, emptyTile.index);
        int score = _calculateScore(newTiles, gridSize);
        
        if (stuckCounter > 5) {
          score += _random.nextInt(20) - 10;
        }

        if (score > bestScore) {
          bestScore = score;
          bestMove = tileToMove.index;
        }
      }

      if (bestMove != null) {
        final emptyIndex = currentTiles.indexWhere((t) => t.isEmpty);
        currentTiles = _moveTile(currentTiles, bestMove, emptyIndex);
        moves.add(bestMove);
        
        final newScore = _calculateScore(currentTiles, gridSize);
        if (newScore <= lastScore) {
          stuckCounter++;
        } else {
          stuckCounter = 0;
        }
        lastScore = newScore;
      } else {
        break;
      }
    }

    return moves;
  }

  int _calculateScore(List<Tile> tiles, int gridSize) {
    int score = 0;
    for (final tile in tiles) {
      if (tile.isInCorrectPosition) {
        score += 10;
      } else {
        final currentRow = tile.currentPosition ~/ gridSize;
        final currentCol = tile.currentPosition % gridSize;
        final correctRow = tile.correctPosition ~/ gridSize;
        final correctCol = tile.correctPosition % gridSize;
        final distance = (currentRow - correctRow).abs() + (currentCol - correctCol).abs();
        score -= distance;
      }
    }
    return score;
  }

  List<Tile> _moveTile(List<Tile> tiles, int tileIndex, int emptyIndex) {
    final newTiles = List<Tile>.from(tiles);
    final tempPosition = newTiles[emptyIndex].currentPosition;
    newTiles[emptyIndex] = newTiles[emptyIndex].copyWith(
      currentPosition: newTiles[tileIndex].currentPosition,
    );
    newTiles[tileIndex] = newTiles[tileIndex].copyWith(
      currentPosition: tempPosition,
    );
    return newTiles;
  }

  List<int> _getPossibleMoves(int emptyPosition, int gridSize) {
    final moves = <int>[];
    final row = emptyPosition ~/ gridSize;
    final col = emptyPosition % gridSize;

    if (row > 0) moves.add(emptyPosition - gridSize);
    if (row < gridSize - 1) moves.add(emptyPosition + gridSize);
    if (col > 0) moves.add(emptyPosition - 1);
    if (col < gridSize - 1) moves.add(emptyPosition + 1);

    return moves;
  }

  bool _isSolved(List<Tile> tiles) {
    return tiles.every((tile) => tile.isInCorrectPosition);
  }
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/tile.dart';
import '../models/puzzle_config.dart';
import '../models/score.dart';
import '../core/constants/app_constants.dart';
import '../services/image_service.dart';
import '../services/storage_service.dart';

class GameState {
  final List<Tile> tiles;
  final int moves;
  final int timeSeconds;
  final bool isLoading;
  final bool isCompleted;
  final DifficultyLevel difficulty;
  final PuzzleConfig puzzle;
  final String? error;

  const GameState({
    required this.tiles,
    required this.moves,
    required this.timeSeconds,
    required this.isLoading,
    required this.isCompleted,
    required this.difficulty,
    required this.puzzle,
    this.error,
  });

  GameState copyWith({
    List<Tile>? tiles,
    int? moves,
    int? timeSeconds,
    bool? isLoading,
    bool? isCompleted,
    DifficultyLevel? difficulty,
    PuzzleConfig? puzzle,
    String? error,
  }) {
    return GameState(
      tiles: tiles ?? this.tiles,
      moves: moves ?? this.moves,
      timeSeconds: timeSeconds ?? this.timeSeconds,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      difficulty: difficulty ?? this.difficulty,
      puzzle: puzzle ?? this.puzzle,
      error: error ?? this.error,
    );
  }

  int get finalScore {
    final baseScore = difficulty.startingPoints;
    final penalty = moves * difficulty.pointsPerMove;
    final score = baseScore - penalty;
    return score < 0 ? 0 : score;
  }
}

class GameNotifier extends StateNotifier<GameState> {
  final ImageService _imageService = ImageService();
  Timer? _timer;

  GameNotifier(PuzzleConfig puzzle, DifficultyLevel difficulty)
      : super(GameState(
          tiles: [],
          moves: 0,
          timeSeconds: 0,
          isLoading: true,
          isCompleted: false,
          difficulty: difficulty,
          puzzle: puzzle,
        )) {
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    try {
      final imageData = await _imageService.downloadImage(state.puzzle.imageUrl);
      final tiles = await _imageService.splitImageIntoTiles(
        imageData,
        state.difficulty.gridSize,
      );
      final shuffledTiles = _imageService.shuffleTiles(
        tiles,
        state.difficulty.gridSize,
      );

      state = state.copyWith(
        tiles: shuffledTiles,
        isLoading: false,
      );

      _startTimer();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load puzzle: $e',
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isCompleted) {
        state = state.copyWith(timeSeconds: state.timeSeconds + 1);
      }
    });
  }

  void moveTile(int tileIndex) {
    if (state.isCompleted || state.isLoading) return;

    final tiles = List<Tile>.from(state.tiles);
    final emptyTile = tiles.firstWhere((tile) => tile.isEmpty);
    final tappedTile = tiles[tileIndex];

    if (_imageService.canMoveTile(
      tappedTile.currentPosition,
      emptyTile.currentPosition,
      state.difficulty.gridSize,
    )) {
      final emptyIndex = tiles.indexOf(emptyTile);
      final tappedIndex = tiles.indexOf(tappedTile);

      final tempPosition = tiles[emptyIndex].currentPosition;
      tiles[emptyIndex] = tiles[emptyIndex].copyWith(
        currentPosition: tiles[tappedIndex].currentPosition,
      );
      tiles[tappedIndex] = tiles[tappedIndex].copyWith(
        currentPosition: tempPosition,
      );

      final newMoves = state.moves + 1;
      final isSolved = _imageService.isPuzzleSolved(tiles);

      state = state.copyWith(
        tiles: tiles,
        moves: newMoves,
        isCompleted: isSolved,
      );

      if (isSolved) {
        _timer?.cancel();
        _saveScore();
      }
    }
  }

  Future<void> _saveScore() async {
    final score = Score(
      id: const Uuid().v4(),
      puzzleId: state.puzzle.id,
      puzzleTitle: state.puzzle.title,
      level: state.difficulty.gridSize,
      score: state.finalScore,
      moves: state.moves,
      timeSeconds: state.timeSeconds,
      completedAt: DateTime.now(),
    );

    final storage = await StorageService.getInstance();
    await storage.saveScore(score);
  }

  void resetGame() {
    _timer?.cancel();
    final shuffledTiles = _imageService.shuffleTiles(
      state.tiles,
      state.difficulty.gridSize,
    );
    state = state.copyWith(
      tiles: shuffledTiles,
      moves: 0,
      timeSeconds: 0,
      isCompleted: false,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final gameProvider = StateNotifierProvider.family<GameNotifier, GameState, Map<String, dynamic>>(
  (ref, params) {
    final puzzle = params['puzzle'] as PuzzleConfig;
    final difficulty = params['difficulty'] as DifficultyLevel;
    return GameNotifier(
      puzzle,
      difficulty,
    );
  },
);

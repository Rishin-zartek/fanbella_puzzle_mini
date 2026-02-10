import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/puzzle_config.dart';
import '../core/constants/puzzle_data.dart';

final puzzleListProvider = Provider<List<PuzzleConfig>>((ref) {
  return PuzzleData.moviePuzzles
      .map((data) => PuzzleConfig.fromJson(data))
      .toList();
});

final selectedPuzzleProvider = StateProvider<PuzzleConfig?>((ref) => null);

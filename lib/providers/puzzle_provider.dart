import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/puzzle_config.dart';
import '../core/constants/puzzle_data.dart';

final puzzleListProvider = Provider<List<PuzzleConfig>>((ref) {
  try {
    final puzzles = PuzzleData.moviePuzzles
        .map((data) => PuzzleConfig.fromJson(data))
        .toList();
    
    if (puzzles.isEmpty) {
      debugPrint('Warning: No puzzles loaded');
    }
    
    return puzzles;
  } catch (e, stackTrace) {
    debugPrint('Error loading puzzles: $e');
    debugPrint('Stack trace: $stackTrace');
    // Return empty list instead of throwing
    return [];
  }
});

final selectedPuzzleProvider = StateProvider<PuzzleConfig?>((ref) => null);

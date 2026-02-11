import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/score.dart';
import '../core/constants/app_constants.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      try {
        _prefs = await SharedPreferences.getInstance();
      } catch (e) {
        print('Warning: Failed to initialize SharedPreferences: $e');
        // Continue without SharedPreferences - app will work but won't save scores
      }
    }
    return _instance!;
  }

  Future<void> saveScore(Score score) async {
    if (_prefs == null) {
      print('Warning: Cannot save score - SharedPreferences not initialized');
      return;
    }
    
    try {
      final scores = await getScores();
      scores.add(score);
      
      final scoresJson = scores.map((s) => s.toJson()).toList();
      await _prefs!.setString(AppConstants.scoresKey, jsonEncode(scoresJson));
    } catch (e) {
      print('Error saving score: $e');
    }
  }

  Future<List<Score>> getScores() async {
    if (_prefs == null) return [];
    
    try {
      final scoresString = _prefs!.getString(AppConstants.scoresKey);
      if (scoresString == null) return [];

      final List<dynamic> scoresJson = jsonDecode(scoresString);
      return scoresJson.map((json) => Score.fromJson(json)).toList();
    } catch (e) {
      print('Error loading scores: $e');
      return [];
    }
  }

  Future<List<Score>> getDailyScores() async {
    final scores = await getScores();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return scores.where((score) {
      final scoreDate = DateTime(
        score.completedAt.year,
        score.completedAt.month,
        score.completedAt.day,
      );
      return scoreDate == today;
    }).toList();
  }

  Future<List<Score>> getWeeklyScores() async {
    final scores = await getScores();
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
    
    return scores.where((score) {
      return score.completedAt.isAfter(weekStartDate);
    }).toList();
  }

  Future<List<Score>> getMonthlyScores() async {
    final scores = await getScores();
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    
    return scores.where((score) {
      return score.completedAt.isAfter(monthStart);
    }).toList();
  }

  Future<List<Score>> getScoresByPuzzle(String puzzleId) async {
    final scores = await getScores();
    return scores.where((score) => score.puzzleId == puzzleId).toList();
  }

  Future<Score?> getBestScoreForPuzzle(String puzzleId, int level) async {
    final scores = await getScoresByPuzzle(puzzleId);
    final levelScores = scores.where((s) => s.level == level).toList();
    
    if (levelScores.isEmpty) return null;
    
    levelScores.sort((a, b) => b.score.compareTo(a.score));
    return levelScores.first;
  }

  Future<void> clearAllScores() async {
    if (_prefs == null) return;
    
    try {
      await _prefs!.remove(AppConstants.scoresKey);
    } catch (e) {
      print('Error clearing scores: $e');
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/score.dart';
import '../services/storage_service.dart';

final storageServiceProvider = FutureProvider<StorageService>((ref) async {
  return await StorageService.getInstance();
});

final allScoresProvider = FutureProvider<List<Score>>((ref) async {
  final storage = await ref.watch(storageServiceProvider.future);
  return await storage.getScores();
});

final dailyScoresProvider = FutureProvider<List<Score>>((ref) async {
  final storage = await ref.watch(storageServiceProvider.future);
  final scores = await storage.getDailyScores();
  scores.sort((a, b) => b.score.compareTo(a.score));
  return scores;
});

final weeklyScoresProvider = FutureProvider<List<Score>>((ref) async {
  final storage = await ref.watch(storageServiceProvider.future);
  final scores = await storage.getWeeklyScores();
  scores.sort((a, b) => b.score.compareTo(a.score));
  return scores;
});

final monthlyScoresProvider = FutureProvider<List<Score>>((ref) async {
  final storage = await ref.watch(storageServiceProvider.future);
  final scores = await storage.getMonthlyScores();
  scores.sort((a, b) => b.score.compareTo(a.score));
  return scores;
});

final allTimeScoresProvider = FutureProvider<List<Score>>((ref) async {
  final storage = await ref.watch(storageServiceProvider.future);
  final scores = await storage.getScores();
  scores.sort((a, b) => b.score.compareTo(a.score));
  return scores;
});

import 'package:flutter/material.dart';
import '../../models/puzzle_config.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../game/game_screen.dart';

class CompletionScreen extends StatelessWidget {
  final PuzzleConfig puzzle;
  final DifficultyLevel difficulty;
  final int score;
  final int moves;
  final int timeSeconds;

  const CompletionScreen({
    super.key,
    required this.puzzle,
    required this.difficulty,
    required this.score,
    required this.moves,
    required this.timeSeconds,
  });

  String get _formattedTime {
    final minutes = timeSeconds ~/ 60;
    final seconds = timeSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Completed!'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppTheme.gold,
                size: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                '🎉 Congratulations! 🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'You completed "${puzzle.title}"',
                style: TextStyle(
                  fontSize: 18,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _ScoreRow(
                        label: 'Difficulty',
                        value: difficulty.label,
                        icon: Icons.grid_4x4,
                      ),
                      const Divider(height: 32),
                      _ScoreRow(
                        label: 'Final Score',
                        value: score.toString(),
                        icon: Icons.star,
                        valueColor: AppTheme.gold,
                        isLarge: true,
                      ),
                      const Divider(height: 32),
                      _ScoreRow(
                        label: 'Moves',
                        value: moves.toString(),
                        icon: Icons.touch_app,
                      ),
                      const SizedBox(height: 16),
                      _ScoreRow(
                        label: 'Time',
                        value: _formattedTime,
                        icon: Icons.timer,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameScreen(
                              puzzle: puzzle,
                              difficulty: difficulty,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Play Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Home'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppTheme.primaryRed),
                        foregroundColor: AppTheme.primaryRed,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final bool isLarge;

  const _ScoreRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryRed,
              size: isLarge ? 28 : 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: isLarge ? 18 : 16,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 32 : 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

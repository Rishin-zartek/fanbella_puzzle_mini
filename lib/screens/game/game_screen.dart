import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/puzzle_config.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/game_provider.dart';
import '../../widgets/puzzle_grid.dart';
import '../completion/completion_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  final PuzzleConfig puzzle;
  final DifficultyLevel difficulty;

  const GameScreen({
    super.key,
    required this.puzzle,
    required this.difficulty,
  });

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(
      gameProvider({
        'puzzle': widget.puzzle,
        'difficulty': widget.difficulty,
      }),
    );

    if (gameState.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompletionScreen(
              puzzle: widget.puzzle,
              difficulty: widget.difficulty,
              score: gameState.finalScore,
              moves: gameState.moves,
              timeSeconds: gameState.timeSeconds,
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.puzzle.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(gameProvider({
                    'puzzle': widget.puzzle,
                    'difficulty': widget.difficulty,
                  }).notifier)
                  .resetGame();
            },
          ),
        ],
      ),
      body: gameState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryRed),
            )
          : gameState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.primaryRed,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        gameState.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _GameStats(
                        moves: gameState.moves,
                        timeSeconds: gameState.timeSeconds,
                        currentScore: gameState.finalScore,
                      ),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          final gridWidth = maxWidth > 500 ? 500.0 : maxWidth;
                          
                          return Center(
                            child: PuzzleGrid(
                              tiles: gameState.tiles,
                              gridSize: widget.difficulty.gridSize,
                              gridWidth: gridWidth,
                              onTileTap: (index) {
                                ref
                                    .read(gameProvider({
                                      'puzzle': widget.puzzle,
                                      'difficulty': widget.difficulty,
                                    }).notifier)
                                    .moveTile(index);
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _DifficultyInfo(difficulty: widget.difficulty),
                    ],
                  ),
                ),
    );
  }
}

class _GameStats extends StatelessWidget {
  final int moves;
  final int timeSeconds;
  final int currentScore;

  const _GameStats({
    required this.moves,
    required this.timeSeconds,
    required this.currentScore,
  });

  String get _formattedTime {
    final minutes = timeSeconds ~/ 60;
    final seconds = timeSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              icon: Icons.touch_app,
              label: 'Moves',
              value: moves.toString(),
            ),
            _StatItem(
              icon: Icons.timer,
              label: 'Time',
              value: _formattedTime,
            ),
            _StatItem(
              icon: Icons.star,
              label: 'Score',
              value: currentScore.toString(),
              valueColor: AppTheme.gold,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryRed, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _DifficultyInfo extends StatelessWidget {
  final DifficultyLevel difficulty;

  const _DifficultyInfo({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardBackground.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${difficulty.label} Mode',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Starting: ${difficulty.startingPoints} pts • Penalty: -${difficulty.pointsPerMove} per move',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

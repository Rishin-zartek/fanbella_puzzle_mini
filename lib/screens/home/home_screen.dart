import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/puzzle_provider.dart';
import '../../core/theme/app_theme.dart';
import '../difficulty/difficulty_screen.dart';
import '../leaderboard/leaderboard_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzles = ref.watch(puzzleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'Movie Puzzle Game',
          header: true,
          child: const Text('🎬 Movie Puzzle Game', key: Key('app_title')),
        ),
        actions: [
          Semantics(
            label: 'View Leaderboard',
            button: true,
            child: IconButton(
              key: const Key('leaderboard_button'),
              icon: const Icon(Icons.leaderboard, color: AppTheme.gold),
              tooltip: 'Leaderboard',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Choose a Puzzle',
              header: true,
              child: Text(
                'Choose a Puzzle',
                key: const Key('choose_puzzle_header'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.gold,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: puzzles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.movie_outlined,
                            size: 64,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No puzzles available',
                            key: const Key('no_puzzles_text'),
                            style: const TextStyle(
                              fontSize: 18,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      key: const Key('puzzle_grid'),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: puzzles.length,
                      itemBuilder: (context, index) {
                        final puzzle = puzzles[index];
                        return GestureDetector(
                          key: Key('puzzle_card_$index'),
                          onTap: () {
                            ref.read(selectedPuzzleProvider.notifier).state = puzzle;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DifficultyScreen(),
                              ),
                            );
                          },
                          child: Semantics(
                            label: 'Puzzle: ${puzzle.title}. ${puzzle.description}',
                            button: true,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      puzzle.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        debugPrint('Error loading image ${puzzle.imageUrl}: $error');
                                        return Container(
                                          color: AppTheme.cardBackground,
                                          child: const Icon(
                                            Icons.error_outline,
                                            color: AppTheme.primaryRed,
                                            size: 48,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          puzzle.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          puzzle.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

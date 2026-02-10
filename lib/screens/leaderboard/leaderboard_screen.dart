import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/score.dart';
import '../../models/leaderboard_entry.dart';
import '../../providers/score_provider.dart';
import '../../core/theme/app_theme.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Leaderboards'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.gold,
          labelColor: AppTheme.gold,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'All Time'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LeaderboardTab(provider: dailyScoresProvider),
          _LeaderboardTab(provider: weeklyScoresProvider),
          _LeaderboardTab(provider: monthlyScoresProvider),
          _LeaderboardTab(provider: allTimeScoresProvider),
        ],
      ),
    );
  }
}

class _LeaderboardTab extends ConsumerWidget {
  final FutureProvider<List<Score>> provider;

  const _LeaderboardTab({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(provider);

    return scoresAsync.when(
      data: (scores) {
        if (scores.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: AppTheme.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No scores yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete a puzzle to see your score here!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        final entries = scores
            .asMap()
            .entries
            .map((e) => LeaderboardEntry.fromScore(e.value, rank: e.key + 1))
            .toList();

        final topThree = entries.take(3).toList();
        final remaining = entries.skip(3).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (topThree.isNotEmpty) ...[
                _PodiumWidget(topThree: topThree),
                const SizedBox(height: 24),
              ],
              if (remaining.isNotEmpty) ...[
                ...remaining.map((entry) => _LeaderboardCard(entry: entry)),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryRed),
      ),
      error: (error, stack) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

class _PodiumWidget extends StatelessWidget {
  final List<LeaderboardEntry> topThree;

  const _PodiumWidget({required this.topThree});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (topThree.length > 1)
              _PodiumPlace(
                entry: topThree[1],
                medal: '🥈',
                height: 100,
              ),
            if (topThree.isNotEmpty)
              _PodiumPlace(
                entry: topThree[0],
                medal: '🥇',
                height: 130,
              ),
            if (topThree.length > 2)
              _PodiumPlace(
                entry: topThree[2],
                medal: '🥉',
                height: 80,
              ),
          ],
        ),
      ),
    );
  }
}

class _PodiumPlace extends StatelessWidget {
  final LeaderboardEntry entry;
  final String medal;
  final double height;

  const _PodiumPlace({
    required this.entry,
    required this.medal,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          medal,
          style: const TextStyle(fontSize: 40),
        ),
        const SizedBox(height: 8),
        Text(
          entry.score.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.gold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: AppTheme.primaryRed.withOpacity(0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: AppTheme.primaryRed, width: 2),
          ),
          child: Center(
            child: Text(
              '#${entry.rank}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;

  const _LeaderboardCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryRed,
          child: Text(
            '#${entry.rank}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          entry.puzzleTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${entry.difficultyLabel} • ${entry.moves} moves • ${entry.formattedTime}',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: AppTheme.gold, size: 20),
                const SizedBox(width: 4),
                Text(
                  entry.score.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.gold,
                  ),
                ),
              ],
            ),
            Text(
              DateFormat('MMM d').format(entry.completedAt),
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

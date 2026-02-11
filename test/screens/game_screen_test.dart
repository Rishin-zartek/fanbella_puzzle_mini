import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_puzzle_game/screens/game/game_screen.dart';
import 'package:movie_puzzle_game/models/puzzle_config.dart';
import 'package:movie_puzzle_game/core/constants/app_constants.dart';

void main() {
  group('GameScreen Widget Tests', () {
    late PuzzleConfig testPuzzle;

    setUp(() {
      testPuzzle = PuzzleConfig(
        id: 'puzzle_1',
        title: 'Classic Cinema',
        imageUrl: 'assets/images/puzzle_1.jpg',
        description: 'Vintage movie theater',
      );
    });

    testWidgets('Game screen loads and displays puzzle grid', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GameScreen(
              puzzle: testPuzzle,
              difficulty: DifficultyLevel.easy,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Classic Cinema'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.text('Moves'), findsOneWidget);
      expect(find.text('Time'), findsOneWidget);
      expect(find.text('Score'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1000'), findsOneWidget);
    });

    testWidgets('Game screen shows correct difficulty info', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GameScreen(
              puzzle: testPuzzle,
              difficulty: DifficultyLevel.medium,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Medium Mode'), findsOneWidget);
      expect(find.textContaining('1500 pts'), findsOneWidget);
      expect(find.textContaining('-15 per move'), findsOneWidget);
    });

    testWidgets('Refresh button resets the game', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GameScreen(
              puzzle: testPuzzle,
              difficulty: DifficultyLevel.easy,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));

      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);

      await tester.tap(refreshButton);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
    });
  });
}

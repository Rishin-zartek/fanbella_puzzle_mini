import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_puzzle_game/models/tile.dart';

void main() {
  group('Tile', () {
    test('creates tile with required properties', () {
      final tile = Tile(
        index: 0,
        currentPosition: 0,
        correctPosition: 0,
      );

      expect(tile.index, 0);
      expect(tile.currentPosition, 0);
      expect(tile.correctPosition, 0);
      expect(tile.isEmpty, false);
      expect(tile.imageData, isNull);
    });

    test('creates empty tile', () {
      final tile = Tile(
        index: 8,
        currentPosition: 8,
        correctPosition: 8,
        isEmpty: true,
      );

      expect(tile.isEmpty, true);
    });

    test('isInCorrectPosition returns true when positions match', () {
      final tile = Tile(
        index: 0,
        currentPosition: 0,
        correctPosition: 0,
      );

      expect(tile.isInCorrectPosition, true);
    });

    test('isInCorrectPosition returns false when positions do not match', () {
      final tile = Tile(
        index: 0,
        currentPosition: 1,
        correctPosition: 0,
      );

      expect(tile.isInCorrectPosition, false);
    });

    test('copyWith creates new tile with updated properties', () {
      final tile = Tile(
        index: 0,
        currentPosition: 0,
        correctPosition: 0,
      );

      final updatedTile = tile.copyWith(currentPosition: 1);

      expect(updatedTile.index, 0);
      expect(updatedTile.currentPosition, 1);
      expect(updatedTile.correctPosition, 0);
    });

    test('copyWith preserves original properties when not specified', () {
      final imageData = Uint8List.fromList([1, 2, 3]);
      final tile = Tile(
        index: 0,
        currentPosition: 0,
        correctPosition: 0,
        imageData: imageData,
        isEmpty: false,
      );

      final updatedTile = tile.copyWith(currentPosition: 1);

      expect(updatedTile.imageData, imageData);
      expect(updatedTile.isEmpty, false);
    });

    test('equality works correctly', () {
      final tile1 = Tile(
        index: 0,
        currentPosition: 0,
        correctPosition: 0,
      );

      final tile2 = Tile(
        index: 0,
        currentPosition: 0,
        correctPosition: 0,
      );

      final tile3 = Tile(
        index: 0,
        currentPosition: 1,
        correctPosition: 0,
      );

      expect(tile1 == tile2, true);
      expect(tile1 == tile3, false);
    });

    test('hashCode is consistent', () {
      final tile1 = Tile(
        index: 0,
        currentPosition: 0,
        correctPosition: 0,
      );

      final tile2 = Tile(
        index: 0,
        currentPosition: 0,
        correctPosition: 0,
      );

      expect(tile1.hashCode, tile2.hashCode);
    });
  });
}

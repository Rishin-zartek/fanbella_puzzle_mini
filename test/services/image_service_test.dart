import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_puzzle_game/services/image_service.dart';
import 'package:movie_puzzle_game/models/tile.dart';
import 'package:image/image.dart' as img;

void main() {
  group('ImageService', () {
    late ImageService imageService;

    setUp(() {
      imageService = ImageService();
    });

    group('splitImageIntoTiles', () {
      test('splits image into correct number of tiles', () async {
        final image = img.Image(width: 300, height: 300);
        img.fill(image, color: img.ColorRgb8(255, 0, 0));
        final imageData = Uint8List.fromList(img.encodePng(image));

        final tiles = await imageService.splitImageIntoTiles(imageData, 3);

        expect(tiles.length, 9);
      });

      test('last tile is empty', () async {
        final image = img.Image(width: 300, height: 300);
        img.fill(image, color: img.ColorRgb8(255, 0, 0));
        final imageData = Uint8List.fromList(img.encodePng(image));

        final tiles = await imageService.splitImageIntoTiles(imageData, 3);

        expect(tiles.last.isEmpty, true);
        expect(tiles.last.imageData, isNull);
      });

      test('non-empty tiles have image data', () async {
        final image = img.Image(width: 300, height: 300);
        img.fill(image, color: img.ColorRgb8(255, 0, 0));
        final imageData = Uint8List.fromList(img.encodePng(image));

        final tiles = await imageService.splitImageIntoTiles(imageData, 3);

        for (int i = 0; i < tiles.length - 1; i++) {
          expect(tiles[i].isEmpty, false);
          expect(tiles[i].imageData, isNotNull);
        }
      });

      test('tiles have correct initial positions', () async {
        final image = img.Image(width: 300, height: 300);
        img.fill(image, color: img.ColorRgb8(255, 0, 0));
        final imageData = Uint8List.fromList(img.encodePng(image));

        final tiles = await imageService.splitImageIntoTiles(imageData, 3);

        for (int i = 0; i < tiles.length; i++) {
          expect(tiles[i].index, i);
          expect(tiles[i].currentPosition, i);
          expect(tiles[i].correctPosition, i);
        }
      });

      test('throws exception for invalid image data', () async {
        final invalidData = Uint8List.fromList([1, 2, 3, 4]);

        expect(
          () => imageService.splitImageIntoTiles(invalidData, 3),
          throwsA(isA<Error>()),
        );
      });

      test('works with different grid sizes', () async {
        final image = img.Image(width: 400, height: 400);
        img.fill(image, color: img.ColorRgb8(255, 0, 0));
        final imageData = Uint8List.fromList(img.encodePng(image));

        final tiles2x2 = await imageService.splitImageIntoTiles(imageData, 2);
        expect(tiles2x2.length, 4);

        final tiles4x4 = await imageService.splitImageIntoTiles(imageData, 4);
        expect(tiles4x4.length, 16);

        final tiles5x5 = await imageService.splitImageIntoTiles(imageData, 5);
        expect(tiles5x5.length, 25);
      });
    });

    group('shuffleTiles', () {
      test('returns same number of tiles', () {
        final tiles = List.generate(
          9,
          (i) => Tile(
            index: i,
            currentPosition: i,
            correctPosition: i,
            isEmpty: i == 8,
          ),
        );

        final shuffled = imageService.shuffleTiles(tiles, 3);

        expect(shuffled.length, tiles.length);
      });

      test('preserves tile indices', () {
        final tiles = List.generate(
          9,
          (i) => Tile(
            index: i,
            currentPosition: i,
            correctPosition: i,
            isEmpty: i == 8,
          ),
        );

        final shuffled = imageService.shuffleTiles(tiles, 3);

        final indices = shuffled.map((t) => t.index).toList()..sort();
        expect(indices, [0, 1, 2, 3, 4, 5, 6, 7, 8]);
      });

      test('preserves correct positions', () {
        final tiles = List.generate(
          9,
          (i) => Tile(
            index: i,
            currentPosition: i,
            correctPosition: i,
            isEmpty: i == 8,
          ),
        );

        final shuffled = imageService.shuffleTiles(tiles, 3);

        for (int i = 0; i < shuffled.length; i++) {
          expect(shuffled[i].correctPosition, shuffled[i].index);
        }
      });

      test('preserves empty tile', () {
        final tiles = List.generate(
          9,
          (i) => Tile(
            index: i,
            currentPosition: i,
            correctPosition: i,
            isEmpty: i == 8,
          ),
        );

        final shuffled = imageService.shuffleTiles(tiles, 3);

        final emptyTiles = shuffled.where((t) => t.isEmpty).toList();
        expect(emptyTiles.length, 1);
        expect(emptyTiles.first.index, 8);
      });
    });

    group('canMoveTile', () {
      test('returns true for adjacent tiles horizontally', () {
        expect(imageService.canMoveTile(0, 1, 3), true);
        expect(imageService.canMoveTile(1, 0, 3), true);
        expect(imageService.canMoveTile(1, 2, 3), true);
        expect(imageService.canMoveTile(2, 1, 3), true);
      });

      test('returns true for adjacent tiles vertically', () {
        expect(imageService.canMoveTile(0, 3, 3), true);
        expect(imageService.canMoveTile(3, 0, 3), true);
        expect(imageService.canMoveTile(3, 6, 3), true);
        expect(imageService.canMoveTile(6, 3, 3), true);
      });

      test('returns false for non-adjacent tiles', () {
        expect(imageService.canMoveTile(0, 2, 3), false);
        expect(imageService.canMoveTile(0, 4, 3), false);
        expect(imageService.canMoveTile(0, 8, 3), false);
      });

      test('returns false for diagonal tiles', () {
        expect(imageService.canMoveTile(0, 4, 3), false);
        expect(imageService.canMoveTile(1, 3, 3), false);
        expect(imageService.canMoveTile(4, 8, 3), false);
      });

      test('handles edge cases correctly', () {
        expect(imageService.canMoveTile(0, 1, 3), true);
        expect(imageService.canMoveTile(0, 3, 3), true);
        expect(imageService.canMoveTile(2, 1, 3), true);
        expect(imageService.canMoveTile(2, 5, 3), true);
        expect(imageService.canMoveTile(6, 3, 3), true);
        expect(imageService.canMoveTile(6, 7, 3), true);
        expect(imageService.canMoveTile(8, 5, 3), true);
        expect(imageService.canMoveTile(8, 7, 3), true);
      });
    });

    group('isPuzzleSolved', () {
      test('returns true when all tiles are in correct position', () {
        final tiles = List.generate(
          9,
          (i) => Tile(
            index: i,
            currentPosition: i,
            correctPosition: i,
            isEmpty: i == 8,
          ),
        );

        expect(imageService.isPuzzleSolved(tiles), true);
      });

      test('returns false when any tile is not in correct position', () {
        final tiles = List.generate(
          9,
          (i) => Tile(
            index: i,
            currentPosition: i,
            correctPosition: i,
            isEmpty: i == 8,
          ),
        );

        tiles[0] = tiles[0].copyWith(currentPosition: 1);
        tiles[1] = tiles[1].copyWith(currentPosition: 0);

        expect(imageService.isPuzzleSolved(tiles), false);
      });

      test('returns false when multiple tiles are out of position', () {
        final tiles = List.generate(
          9,
          (i) => Tile(
            index: i,
            currentPosition: (i + 1) % 9,
            correctPosition: i,
            isEmpty: i == 8,
          ),
        );

        expect(imageService.isPuzzleSolved(tiles), false);
      });
    });
  });
}

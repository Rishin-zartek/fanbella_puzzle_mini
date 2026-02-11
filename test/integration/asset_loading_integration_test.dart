import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_puzzle_game/services/image_service.dart';
import 'package:movie_puzzle_game/core/constants/puzzle_data.dart';
import 'package:image/image.dart' as img;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Asset Loading Integration Tests', () {
    late ImageService imageService;

    setUp(() {
      imageService = ImageService();
    });

    tearDown(() {
      // Clean up mock handlers
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    test('loads all puzzle images from assets and splits them into tiles', () async {
      // Create test images for all puzzles
      final testImages = <String, Uint8List>{};
      for (var puzzle in PuzzleData.moviePuzzles) {
        final testImage = img.Image(width: 300, height: 300);
        img.fill(testImage, color: img.ColorRgb8(255, 0, 0));
        testImages[puzzle['imageUrl']!] = Uint8List.fromList(img.encodePng(testImage));
      }

      // Mock the asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final String key = utf8.decode(message!.buffer.asUint8List());
        if (testImages.containsKey(key)) {
          return ByteData.view(testImages[key]!.buffer);
        }
        return null;
      });

      // Test loading and splitting each puzzle image
      for (var puzzle in PuzzleData.moviePuzzles) {
        final imageUrl = puzzle['imageUrl']!;
        
        // Load image from assets
        final imageData = await imageService.loadImageFromAssets(imageUrl);
        expect(imageData, isNotNull);
        expect(imageData.length, greaterThan(0));

        // Split into tiles for easy difficulty (3x3)
        final tiles = await imageService.splitImageIntoTiles(imageData, 3);
        expect(tiles.length, 9);
        expect(tiles.last.isEmpty, true);
        
        // Verify all non-empty tiles have image data
        for (int i = 0; i < tiles.length - 1; i++) {
          expect(tiles[i].imageData, isNotNull);
          expect(tiles[i].isEmpty, false);
        }
      }
    });

    test('handles asset loading failure gracefully', () async {
      // Mock the asset bundle to return null (simulating missing asset)
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return null;
      });

      expect(
        () => imageService.loadImageFromAssets('assets/images/missing.jpg'),
        throwsA(isA<FlutterError>()),
      );
    });

    test('loads asset and creates tiles for different difficulty levels', () async {
      // Create a test image
      final testImage = img.Image(width: 400, height: 400);
      img.fill(testImage, color: img.ColorRgb8(0, 255, 0));
      final testImageData = Uint8List.fromList(img.encodePng(testImage));

      // Mock the asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final String key = utf8.decode(message!.buffer.asUint8List());
        if (key == 'assets/images/puzzle_1.jpg') {
          return ByteData.view(testImageData.buffer);
        }
        return null;
      });

      // Load image
      final imageData = await imageService.loadImageFromAssets('assets/images/puzzle_1.jpg');

      // Test easy difficulty (3x3)
      final easyTiles = await imageService.splitImageIntoTiles(imageData, 3);
      expect(easyTiles.length, 9);

      // Test medium difficulty (4x4)
      final mediumTiles = await imageService.splitImageIntoTiles(imageData, 4);
      expect(mediumTiles.length, 16);

      // Test hard difficulty (5x5)
      final hardTiles = await imageService.splitImageIntoTiles(imageData, 5);
      expect(hardTiles.length, 25);
    });

    test('loaded asset can be shuffled and solved', () async {
      // Create a test image
      final testImage = img.Image(width: 300, height: 300);
      img.fill(testImage, color: img.ColorRgb8(255, 255, 0));
      final testImageData = Uint8List.fromList(img.encodePng(testImage));

      // Mock the asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final String key = utf8.decode(message!.buffer.asUint8List());
        if (key == 'assets/images/puzzle_3.jpg') {
          return ByteData.view(testImageData.buffer);
        }
        return null;
      });

      // Load and split image
      final imageData = await imageService.loadImageFromAssets('assets/images/puzzle_3.jpg');
      final tiles = await imageService.splitImageIntoTiles(imageData, 3);

      // Verify initial state is solved
      expect(imageService.isPuzzleSolved(tiles), true);

      // Shuffle tiles
      final shuffledTiles = imageService.shuffleTiles(tiles, 3);
      expect(shuffledTiles.length, tiles.length);

      // Verify tiles are preserved
      final indices = shuffledTiles.map((t) => t.index).toList()..sort();
      expect(indices, [0, 1, 2, 3, 4, 5, 6, 7, 8]);
    });

    test('verifies all puzzle data entries have valid asset paths', () {
      // Verify all puzzle entries have the expected structure
      for (var puzzle in PuzzleData.moviePuzzles) {
        expect(puzzle['id'], isNotNull);
        expect(puzzle['title'], isNotNull);
        expect(puzzle['imageUrl'], isNotNull);
        expect(puzzle['description'], isNotNull);
        
        // Verify asset path format
        final imageUrl = puzzle['imageUrl']!;
        expect(imageUrl.startsWith('assets/images/'), true);
        expect(imageUrl.endsWith('.jpg'), true);
      }
    });

    test('loads multiple assets sequentially without errors', () async {
      // Create test images
      final testImage1 = img.Image(width: 200, height: 200);
      img.fill(testImage1, color: img.ColorRgb8(255, 0, 0));
      final testImageData1 = Uint8List.fromList(img.encodePng(testImage1));

      final testImage2 = img.Image(width: 200, height: 200);
      img.fill(testImage2, color: img.ColorRgb8(0, 255, 0));
      final testImageData2 = Uint8List.fromList(img.encodePng(testImage2));

      // Mock the asset bundle
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        final String key = utf8.decode(message!.buffer.asUint8List());
        if (key == 'assets/images/puzzle_1.jpg') {
          return ByteData.view(testImageData1.buffer);
        } else if (key == 'assets/images/puzzle_2.jpg') {
          return ByteData.view(testImageData2.buffer);
        }
        return null;
      });

      // Load multiple assets
      final imageData1 = await imageService.loadImageFromAssets('assets/images/puzzle_1.jpg');
      final imageData2 = await imageService.loadImageFromAssets('assets/images/puzzle_2.jpg');

      expect(imageData1, isNotNull);
      expect(imageData2, isNotNull);
      expect(imageData1.length, greaterThan(0));
      expect(imageData2.length, greaterThan(0));

      // Verify both can be decoded
      final decodedImage1 = img.decodeImage(imageData1);
      final decodedImage2 = img.decodeImage(imageData2);
      
      expect(decodedImage1, isNotNull);
      expect(decodedImage2, isNotNull);
    });
  });
}

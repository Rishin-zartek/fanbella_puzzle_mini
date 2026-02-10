import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import '../models/tile.dart';

class ImageService {
  Future<Uint8List> downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download image: ${response.statusCode}');
    }
  }

  Future<List<Tile>> splitImageIntoTiles(
    Uint8List imageData,
    int gridSize,
  ) async {
    final image = img.decodeImage(imageData);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final tileWidth = image.width ~/ gridSize;
    final tileHeight = image.height ~/ gridSize;
    final tiles = <Tile>[];

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        final index = row * gridSize + col;
        final isLastTile = index == (gridSize * gridSize - 1);

        if (isLastTile) {
          tiles.add(
            Tile(
              index: index,
              currentPosition: index,
              correctPosition: index,
              isEmpty: true,
            ),
          );
        } else {
          final tileCrop = img.copyCrop(
            image,
            x: col * tileWidth,
            y: row * tileHeight,
            width: tileWidth,
            height: tileHeight,
          );

          final tileBytes = Uint8List.fromList(img.encodePng(tileCrop));

          tiles.add(
            Tile(
              index: index,
              currentPosition: index,
              correctPosition: index,
              imageData: tileBytes,
              isEmpty: false,
            ),
          );
        }
      }
    }

    return tiles;
  }

  List<Tile> shuffleTiles(List<Tile> tiles, int gridSize) {
    final shuffledTiles = List<Tile>.from(tiles);
    final emptyIndex = tiles.indexWhere((tile) => tile.isEmpty);
    
    int currentEmptyPos = emptyIndex;
    final random = DateTime.now().millisecondsSinceEpoch;
    
    for (int i = 0; i < gridSize * gridSize * 10; i++) {
      final possibleMoves = _getPossibleMoves(currentEmptyPos, gridSize);
      if (possibleMoves.isEmpty) continue;
      
      final moveIndex = (random + i) % possibleMoves.length;
      final targetPos = possibleMoves[moveIndex];
      
      final emptyTileIndex = shuffledTiles.indexWhere(
        (tile) => tile.currentPosition == currentEmptyPos,
      );
      final targetTileIndex = shuffledTiles.indexWhere(
        (tile) => tile.currentPosition == targetPos,
      );
      
      if (emptyTileIndex != -1 && targetTileIndex != -1) {
        final temp = shuffledTiles[emptyTileIndex].currentPosition;
        shuffledTiles[emptyTileIndex] = shuffledTiles[emptyTileIndex].copyWith(
          currentPosition: shuffledTiles[targetTileIndex].currentPosition,
        );
        shuffledTiles[targetTileIndex] = shuffledTiles[targetTileIndex].copyWith(
          currentPosition: temp,
        );
        currentEmptyPos = targetPos;
      }
    }
    
    return shuffledTiles;
  }

  List<int> _getPossibleMoves(int emptyPosition, int gridSize) {
    final moves = <int>[];
    final row = emptyPosition ~/ gridSize;
    final col = emptyPosition % gridSize;

    if (row > 0) moves.add(emptyPosition - gridSize);
    if (row < gridSize - 1) moves.add(emptyPosition + gridSize);
    if (col > 0) moves.add(emptyPosition - 1);
    if (col < gridSize - 1) moves.add(emptyPosition + 1);

    return moves;
  }

  bool canMoveTile(int tilePosition, int emptyPosition, int gridSize) {
    final possibleMoves = _getPossibleMoves(emptyPosition, gridSize);
    return possibleMoves.contains(tilePosition);
  }

  bool isPuzzleSolved(List<Tile> tiles) {
    return tiles.every((tile) => tile.isInCorrectPosition);
  }
}

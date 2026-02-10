import 'package:flutter/material.dart';
import '../models/tile.dart';
import '../core/constants/app_constants.dart';

class PuzzleGrid extends StatelessWidget {
  final List<Tile> tiles;
  final int gridSize;
  final double gridWidth;
  final Function(int) onTileTap;

  const PuzzleGrid({
    super.key,
    required this.tiles,
    required this.gridSize,
    required this.gridWidth,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileSize = gridWidth / gridSize;

    return SizedBox(
      width: gridWidth,
      height: gridWidth,
      child: Stack(
        children: tiles.asMap().entries.map((entry) {
          final index = entry.key;
          final tile = entry.value;
          final row = tile.currentPosition ~/ gridSize;
          final col = tile.currentPosition % gridSize;

          return AnimatedPositioned(
            key: ValueKey(tile.index),
            duration: AppConstants.tileSlideDuration,
            curve: Curves.easeOut,
            left: col * tileSize,
            top: row * tileSize,
            width: tileSize,
            height: tileSize,
            child: tile.isEmpty
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () => onTileTap(index),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: tile.imageData != null
                            ? Image.memory(
                                tile.imageData!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey,
                                child: Center(
                                  child: Text(
                                    '${tile.index + 1}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }
}

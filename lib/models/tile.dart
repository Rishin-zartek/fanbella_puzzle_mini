import 'dart:typed_data';

class Tile {
  final int index;
  final int currentPosition;
  final int correctPosition;
  final Uint8List? imageData;
  final bool isEmpty;

  const Tile({
    required this.index,
    required this.currentPosition,
    required this.correctPosition,
    this.imageData,
    this.isEmpty = false,
  });

  Tile copyWith({
    int? index,
    int? currentPosition,
    int? correctPosition,
    Uint8List? imageData,
    bool? isEmpty,
  }) {
    return Tile(
      index: index ?? this.index,
      currentPosition: currentPosition ?? this.currentPosition,
      correctPosition: correctPosition ?? this.correctPosition,
      imageData: imageData ?? this.imageData,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  bool get isInCorrectPosition => currentPosition == correctPosition;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tile &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          currentPosition == other.currentPosition;

  @override
  int get hashCode => index.hashCode ^ currentPosition.hashCode;
}

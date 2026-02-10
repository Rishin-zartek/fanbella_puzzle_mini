class AppConstants {
  static const String appName = 'Movie Puzzle Game';
  
  // Grid sizes
  static const int easyGridSize = 3;
  static const int mediumGridSize = 4;
  static const int hardGridSize = 5;
  
  // Scoring
  static const int easyStartingPoints = 1000;
  static const int mediumStartingPoints = 1500;
  static const int hardStartingPoints = 2000;
  
  static const int easyPointsPerMove = 10;
  static const int mediumPointsPerMove = 15;
  static const int hardPointsPerMove = 20;
  
  // Animation
  static const Duration tileSlideDuration = Duration(milliseconds: 200);
  
  // Local storage keys
  static const String scoresKey = 'scores';
  static const String leaderboardsKey = 'leaderboards';
  
  // Leaderboard types
  static const String dailyLeaderboard = 'daily';
  static const String weeklyLeaderboard = 'weekly';
  static const String monthlyLeaderboard = 'monthly';
  static const String allTimeLeaderboard = 'allTime';
}

enum DifficultyLevel {
  easy(
    gridSize: AppConstants.easyGridSize,
    startingPoints: AppConstants.easyStartingPoints,
    pointsPerMove: AppConstants.easyPointsPerMove,
    label: 'Easy',
    description: '3×3 Grid',
  ),
  medium(
    gridSize: AppConstants.mediumGridSize,
    startingPoints: AppConstants.mediumStartingPoints,
    pointsPerMove: AppConstants.mediumPointsPerMove,
    label: 'Medium',
    description: '4×4 Grid',
  ),
  hard(
    gridSize: AppConstants.hardGridSize,
    startingPoints: AppConstants.hardStartingPoints,
    pointsPerMove: AppConstants.hardPointsPerMove,
    label: 'Hard',
    description: '5×5 Grid',
  );

  const DifficultyLevel({
    required this.gridSize,
    required this.startingPoints,
    required this.pointsPerMove,
    required this.label,
    required this.description,
  });

  final int gridSize;
  final int startingPoints;
  final int pointsPerMove;
  final String label;
  final String description;
}

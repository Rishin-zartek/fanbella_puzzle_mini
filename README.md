# 🎬 Movie Puzzle Game

A movie-industry focused sliding puzzle game built with Flutter. Rearrange shuffled image blocks to recreate original movie posters and scenes!

## ✨ Features

### 🎮 Core Gameplay
- **Sliding Puzzle Mechanics**: Classic sliding puzzle with smooth animations
- **Multiple Difficulty Levels**:
  - 🟢 Easy (3×3 grid) - 1000 starting points, -10 per move
  - 🟡 Medium (4×4 grid) - 1500 starting points, -15 per move
  - 🔴 Hard (5×5 grid) - 2000 starting points, -20 per move
- **10 Movie-Themed Puzzles**: Curated images from Pexels featuring cinema themes
- **Real-time Scoring**: Dynamic score calculation based on moves
- **Timer**: Track how long it takes to complete each puzzle

### 🏆 Leaderboards
- **Daily Leaderboard**: Today's best scores
- **Weekly Leaderboard**: This week's top performances
- **Monthly Leaderboard**: Current month's rankings
- **All-Time Leaderboard**: Best scores ever recorded
- **Podium Display**: Special showcase for top 3 players

### 🎨 UI/UX
- **Dark Theme**: Cinematic dark theme with movie-industry colors
- **Smooth Animations**: Fluid tile sliding with AnimatedPositioned
- **Responsive Design**: Works on various screen sizes
- **Material 3 Design**: Modern Flutter UI components
- **Google Fonts**: Beautiful Poppins typography

### 💾 Local Storage
- **Offline Support**: All data stored locally on device
- **No Authentication Required**: Play immediately without sign-up
- **Persistent Scores**: Your achievements are saved automatically

## 🏗️ Architecture

### Clean Architecture
```
lib/
├── core/
│   ├── constants/      # App constants and puzzle data
│   ├── theme/          # App theme configuration
│   └── utils/          # Utility functions
├── models/             # Data models
│   ├── puzzle_config.dart
│   ├── tile.dart
│   ├── score.dart
│   └── leaderboard_entry.dart
├── providers/          # Riverpod state management
│   ├── puzzle_provider.dart
│   ├── game_provider.dart
│   └── score_provider.dart
├── services/           # Business logic services
│   ├── storage_service.dart
│   └── image_service.dart
├── widgets/            # Reusable widgets
│   └── puzzle_grid.dart
├── screens/            # App screens
│   ├── home/
│   ├── difficulty/
│   ├── game/
│   ├── completion/
│   └── leaderboard/
└── main.dart
```

### State Management
- **Riverpod**: Clean, testable state management
- **Provider Pattern**: Separation of concerns
- **Reactive UI**: Automatic updates on state changes

### Key Technologies
- **Flutter 3.38.9**: Cross-platform framework
- **Riverpod 2.6.1**: State management
- **SharedPreferences**: Local data persistence
- **Image Package**: Image manipulation and splitting
- **CachedNetworkImage**: Efficient image loading and caching
- **Google Fonts**: Custom typography

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.8 or higher
- Dart 3.10.8 or higher
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (for iOS development) or Android Emulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Rishin-zartek/fanbella_puzzle_mini.git
cd fanbella_puzzle_mini
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

### Build for Production

**Android APK**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

**Web**
```bash
flutter build web --release
```

## 🎯 How to Play

1. **Select a Puzzle**: Choose from 10 movie-themed images on the home screen
2. **Choose Difficulty**: Pick Easy (3×3), Medium (4×4), or Hard (5×5)
3. **Solve the Puzzle**: Tap tiles adjacent to the empty space to slide them
4. **Track Your Progress**: Watch your moves, time, and current score
5. **Complete & Score**: Finish the puzzle to see your final score
6. **Check Leaderboards**: View your ranking in daily, weekly, monthly, or all-time boards

## 📊 Scoring System

```
Final Score = Starting Points - (Moves × Points Per Move)
Minimum Score = 0 (never negative)

Examples:
- Easy (3×3): Complete in 20 moves = 1000 - (20 × 10) = 800 points
- Medium (4×4): Complete in 30 moves = 1500 - (30 × 15) = 1050 points
- Hard (5×5): Complete in 50 moves = 2000 - (50 × 20) = 1000 points
```

## 🎨 Movie Puzzles

1. **Classic Cinema** - Vintage movie theater
2. **Film Reel** - Old film reel and camera
3. **Clapperboard** - Movie clapperboard scene
4. **Red Carpet** - Hollywood premiere
5. **Popcorn Time** - Cinema popcorn and tickets
6. **Director's Chair** - Film set director chair
7. **Movie Projector** - Vintage projector
8. **Hollywood Sign** - Iconic Hollywood hills
9. **Film Strip** - Classic film strip design
10. **Cinema Seats** - Red velvet theater seats

*All images sourced from Pexels (royalty-free)*

## 🛠️ Development

### Project Structure
- **Models**: Immutable data classes with JSON serialization
- **Services**: Business logic separated from UI
- **Providers**: Riverpod providers for state management
- **Screens**: Feature-based screen organization
- **Widgets**: Reusable UI components

### Key Features Implementation

**Image Splitting**
- Downloads images from Pexels URLs
- Splits into N×N tiles using the `image` package
- Caches split tiles for performance

**Shuffle Algorithm**
- Ensures solvable puzzle configurations
- Uses valid move sequences to shuffle
- Maintains one empty space for sliding

**Leaderboard System**
- Time-based filtering (daily, weekly, monthly)
- Sorted by score (descending)
- Persistent local storage

## 📱 Screenshots

*Coming soon - Add screenshots of your app here*

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: add some amazing feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- **Pexels**: For providing free, high-quality movie-themed images
- **Flutter Team**: For the amazing cross-platform framework
- **Riverpod**: For clean state management
- **Google Fonts**: For beautiful typography

## 📞 Contact

For questions or feedback, please open an issue on GitHub.

---

**Made with ❤️ and Flutter**
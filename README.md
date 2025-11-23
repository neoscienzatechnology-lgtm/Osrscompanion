# OSRS Companion

A comprehensive companion app for Old School RuneScape (OSRS) built with Flutter. This app provides quest guides, skill training methods, XP calculators, money-making guides, and GE price tracking.

## Features

### 🎯 Core Features

- **Quest Guides**: Complete guides for OSRS quests with requirements, rewards, and step-by-step instructions
- **Skill Guides**: Training methods and XP tables for all 23 OSRS skills
- **XP Calculator**: Calculate XP needed and estimated time to reach skill goals
- **Money Making**: Comprehensive list of profitable methods with GP/hour estimates
- **GE Tracker**: Track Grand Exchange prices and price trends
- **XP Goals**: Set and track your skilling goals
- **Favorites**: Quick access to your favorite quests and methods

### 🌍 Internationalization

Supports 4 languages:
- English (en)
- Portuguese (pt-BR)
- Spanish (es)
- German (de)

### 💎 Premium Features

- Ad-free experience
- GE price alerts
- Advanced XP planner
- Premium training routes
- Custom themes

## Screenshots

*Screenshots will be available after building the app*

## Architecture

This app follows Clean Architecture principles with MVVM pattern:

```
lib/
├── core/
│   ├── constants/        # App constants and XP tables
│   ├── models/           # Data models
│   ├── router/           # GoRouter navigation
│   ├── services/         # Data and API services
│   ├── theme/            # App theming (OSRS-inspired dark theme)
│   └── utils/            # Utility functions
├── features/
│   ├── calculators/      # XP calculator
│   ├── favorites/        # Favorites management
│   ├── ge_tracker/       # GE price tracking
│   ├── home/             # Home, splash, language selection
│   ├── money_making/     # Money making methods
│   ├── premium/          # Premium features paywall
│   ├── quests/           # Quest guides
│   ├── settings/         # App settings
│   ├── skills/           # Skill guides
│   └── xp_tracker/       # XP goals tracker
├── l10n/                 # Localization files (.arb)
└── generated/            # Generated localization code
```

## Technologies Used

- **Flutter 3+** with null-safety
- **Riverpod** for state management
- **GoRouter** for navigation
- **Hive** for local storage
- **Material 3** for UI components
- **fl_chart** for price graphs
- **http/dio** for API calls
- **Google Mobile Ads** for monetization
- **In-App Purchase** for premium features

## Data Sources

- Quest data: Static JSON files
- Skill data: Static JSON files with XP tables
- Money-making methods: Static JSON files
- GE Prices: OSRS Wiki API (https://prices.runescape.wiki/api/v1/osrs)

## Setup Instructions

### Prerequisites

1. **Flutter SDK**: Install Flutter 3.0 or later
   - [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
   
2. **IDE**: VS Code or Android Studio
   - VS Code with Flutter and Dart extensions
   - Or Android Studio with Flutter plugin

3. **Platform SDKs**:
   - For Android: Android SDK (API 21+)
   - For iOS: Xcode 14+ (macOS only)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/neoscienzatechnology-lgtm/Osrscompanion.git
   cd Osrscompanion
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files** (if needed)
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS (macOS only):
   ```bash
   cd ios
   pod install
   cd ..
   flutter run
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

#### iOS (macOS only)
```bash
flutter build ios --release
```

Then use Xcode to archive and upload to App Store.

## Configuration

### AdMob Setup

1. Replace the test AdMob App IDs in:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`

2. Current test IDs:
   - Android: `ca-app-pub-3940256099942544~3347511713`
   - iOS: `ca-app-pub-3940256099942544~1458002511`

### App Icons

To generate app icons, place your icon in `assets/icon/icon.png` and run:

```bash
flutter pub run flutter_launcher_icons
```

Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
```

## Project Structure Details

### Core Components

- **AppTheme**: OSRS-inspired dark theme with gold accents
- **AppRouter**: Centralized navigation using GoRouter
- **DataService**: Loads quest, skill, and method data from JSON
- **GeApiService**: Fetches live GE prices from OSRS Wiki API
- **XpUtils**: XP calculations and formatting utilities

### Data Models

- **Quest**: Quest information with requirements and rewards
- **Skill**: Skill data with XP table and training methods
- **MoneyMethod**: Money-making method details
- **GeItem**: GE item with price data
- **XpGoal**: User's XP goals

### Local Storage

Uses Hive for:
- `favorites`: Saved quests and methods
- `settings`: Language preference, premium status
- `goals`: XP goals
- `watchlist`: GE item watchlist

## Contributing

This is a demonstration project. For production use:

1. Add more quest data
2. Expand skill training methods
3. Add more money-making methods
4. Implement actual AdMob ads
5. Implement actual IAP for premium features
6. Add unit and widget tests
7. Improve error handling
8. Add analytics

## API Documentation

### OSRS Wiki API

The app uses the OSRS Wiki Prices API:
- Endpoint: `https://prices.runescape.wiki/api/v1/osrs`
- Documentation: https://oldschool.runescape.wiki/w/RuneScape:Real-time_Prices

Usage:
- Latest prices: `/latest`
- 5-minute data: `/5m?id={itemId}`
- Item mapping: `/mapping`

## License

This project is created for educational purposes. Old School RuneScape and all related content are trademarks of Jagex Ltd.

## Acknowledgments

- Jagex Ltd. for Old School RuneScape
- OSRS Wiki for API and data
- Flutter team for the amazing framework
- All OSRS community contributors

## Support

For issues or questions:
- Open an issue on GitHub
- Contact: [Your Email]

## Roadmap

- [ ] Add remaining quests (currently 5 sample quests)
- [ ] Add all 23 skills (currently 6 sample skills)
- [ ] Implement push notifications for GE alerts
- [ ] Add combat calculator
- [ ] Add boss guides
- [ ] Add achievement diary tracker
- [ ] Implement cloud sync for premium users
- [ ] Add dark/light theme toggle
- [ ] Add search across all content

---

**Made with ❤️ for the OSRS community**

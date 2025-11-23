# AdMob Integration Guide

This guide shows how to implement Google AdMob ads in the OSRS Companion app.

## Setup

### 1. Get AdMob App IDs

1. Create an AdMob account at https://admob.google.com
2. Create a new app for Android and iOS
3. Note your App IDs

### 2. Update Configuration Files

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>
```

### 3. Get Ad Unit IDs

Create ad units for:
- Banner ads
- Interstitial ads
- Rewarded ads

## Implementation

### Create AdMob Service

Create `lib/core/services/admob_service.dart`:

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdMobService {
  static String get bannerAdUnitId {
    if (kDebugMode) {
      // Test IDs
      return defaultTargetPlatform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    // Production IDs
    return defaultTargetPlatform == TargetPlatform.android
        ? 'YOUR_ANDROID_BANNER_ID'
        : 'YOUR_IOS_BANNER_ID';
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return defaultTargetPlatform == TargetPlatform.android
        ? 'YOUR_ANDROID_INTERSTITIAL_ID'
        : 'YOUR_IOS_INTERSTITIAL_ID';
  }

  static String get rewardedAdUnitId {
    if (kDebugMode) {
      return defaultTargetPlatform == TargetPlatform.android
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }
    return defaultTargetPlatform == TargetPlatform.android
        ? 'YOUR_ANDROID_REWARDED_ID'
        : 'YOUR_IOS_REWARDED_ID';
  }

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }
}
```

### Initialize in Main

Update `lib/main.dart`:

```dart
import 'core/services/admob_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('favorites');
  await Hive.openBox('settings');
  await Hive.openBox('goals');
  await Hive.openBox('watchlist');
  
  // Initialize AdMob
  await AdMobService.initialize();
  
  runApp(const ProviderScope(child: OSRSCompanionApp()));
}
```

### Banner Ad Widget

Create `lib/core/widgets/banner_ad_widget.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import '../services/admob_service.dart';

class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    // Check if premium
    final settingsBox = Hive.box('settings');
    final isPremium = settingsBox.get('is_premium', defaultValue: false) as bool;
    
    if (isPremium) return;

    _bannerAd = BannerAd(
      adUnitId: AdMobService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null || !_isLoaded) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
```

### Interstitial Ad Manager

Create `lib/core/services/interstitial_ad_manager.dart`:

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'admob_service.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static int _navigationCount = 0;
  static const int _adFrequency = 10; // Show every 10 navigations

  static void load() {
    final settingsBox = Hive.box('settings');
    final isPremium = settingsBox.get('is_premium', defaultValue: false) as bool;
    
    if (isPremium) return;

    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), load);
        },
      ),
    );
  }

  static void show() {
    _navigationCount++;
    
    if (_navigationCount % _adFrequency != 0) return;

    final settingsBox = Hive.box('settings');
    final isPremium = settingsBox.get('is_premium', defaultValue: false) as bool;
    
    if (isPremium) return;

    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          load(); // Load next ad
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          load();
        },
      );
      
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
```

### Usage in Pages

Add banner ad to bottom of pages:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Quest List')),
    body: Column(
      children: [
        Expanded(
          child: ListView(...),
        ),
        const BannerAdWidget(), // Add banner here
      ],
    ),
  );
}
```

Show interstitial on navigation:

```dart
// In your router or navigation handler
context.push('/quest-details/$id');
InterstitialAdManager.show();
```

### Rewarded Ad Example

For premium content unlock:

```dart
class RewardedAdButton extends StatefulWidget {
  final VoidCallback onRewarded;
  
  const RewardedAdButton({required this.onRewarded, super.key});

  @override
  State<RewardedAdButton> createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends State<RewardedAdButton> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    RewardedAd.load(
      adUnitId: AdMobService.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          // Handle error
        },
      ),
    );
  }

  void _showAd() {
    if (_rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        widget.onRewarded();
      },
    );

    _rewardedAd = null;
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _rewardedAd != null ? _showAd : null,
      child: const Text('Watch Ad to Unlock'),
    );
  }
}
```

## Best Practices

1. **Test with Test IDs First**: Always use test ad unit IDs during development
2. **Check Premium Status**: Don't show ads to premium users
3. **Frequency Capping**: Don't show interstitials too frequently
4. **User Experience**: Place banner ads where they don't interfere with content
5. **Error Handling**: Handle ad loading failures gracefully
6. **Preload Ads**: Load next interstitial after showing one
7. **Dispose Properly**: Always dispose ads in widget dispose

## Privacy & Compliance

1. Add privacy policy URL to app stores
2. Implement consent management for GDPR/CCPA
3. Declare ad serving in privacy policy
4. Follow AdMob policies

## Testing

Test ads appear when:
- Using test ad unit IDs
- Device added to test devices list in AdMob

Production ads appear when:
- Using production ad unit IDs
- App published on stores
- Wait time may be needed after first publish

---

For more information, visit:
- https://developers.google.com/admob/flutter/quick-start
- https://pub.dev/packages/google_mobile_ads

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/language_selection_page.dart';
import '../../features/quests/presentation/pages/quest_list_page.dart';
import '../../features/quests/presentation/pages/quest_details_page.dart';
import '../../features/skills/presentation/pages/skill_list_page.dart';
import '../../features/skills/presentation/pages/skill_details_page.dart';
import '../../features/calculators/presentation/pages/xp_calculator_page.dart';
import '../../features/money_making/presentation/pages/money_making_list_page.dart';
import '../../features/money_making/presentation/pages/money_making_details_page.dart';
import '../../features/ge_tracker/presentation/pages/ge_tracker_page.dart';
import '../../features/ge_tracker/presentation/pages/price_graph_page.dart';
import '../../features/xp_tracker/presentation/pages/xp_goals_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/premium/presentation/pages/premium_paywall_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/language-selection',
        name: 'language-selection',
        builder: (context, state) => const LanguageSelectionPage(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/quests',
        name: 'quests',
        builder: (context, state) => const QuestListPage(),
      ),
      GoRoute(
        path: '/quests/:id',
        name: 'quest-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return QuestDetailsPage(questId: id);
        },
      ),
      GoRoute(
        path: '/skills',
        name: 'skills',
        builder: (context, state) => const SkillListPage(),
      ),
      GoRoute(
        path: '/skills/:id',
        name: 'skill-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SkillDetailsPage(skillId: id);
        },
      ),
      GoRoute(
        path: '/calculators',
        name: 'calculators',
        builder: (context, state) => const XpCalculatorPage(),
      ),
      GoRoute(
        path: '/money-making',
        name: 'money-making',
        builder: (context, state) => const MoneyMakingListPage(),
      ),
      GoRoute(
        path: '/money-making/:id',
        name: 'money-making-details',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MoneyMakingDetailsPage(methodId: id);
        },
      ),
      GoRoute(
        path: '/ge-tracker',
        name: 'ge-tracker',
        builder: (context, state) => const GeTrackerPage(),
      ),
      GoRoute(
        path: '/ge-tracker/:itemId',
        name: 'price-graph',
        builder: (context, state) {
          final itemId = state.pathParameters['itemId']!;
          return PriceGraphPage(itemId: itemId);
        },
      ),
      GoRoute(
        path: '/xp-goals',
        name: 'xp-goals',
        builder: (context, state) => const XpGoalsPage(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/premium',
        name: 'premium',
        builder: (context, state) => const PremiumPaywallPage(),
      ),
    ],
  );
});

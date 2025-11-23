import '../constants/app_constants.dart';

class XpUtils {
  // Get XP required for a level
  static int getXpForLevel(int level) {
    if (level < 1 || level > 99) {
      throw ArgumentError('Level must be between 1 and 99');
    }
    return AppConstants.xpTable[level] ?? 0;
  }
  
  // Get level from XP
  static int getLevelFromXp(int xp) {
    if (xp < 0) return 1;
    if (xp >= AppConstants.xpTable[99]!) return 99;
    
    for (int level = 99; level >= 1; level--) {
      if (xp >= AppConstants.xpTable[level]!) {
        return level;
      }
    }
    return 1;
  }
  
  // Calculate XP needed between two levels
  static int getXpBetweenLevels(int currentLevel, int targetLevel) {
    if (currentLevel >= targetLevel) return 0;
    return getXpForLevel(targetLevel) - getXpForLevel(currentLevel);
  }
  
  // Calculate XP needed from current XP to target level
  static int getXpNeeded(int currentXp, int targetLevel) {
    final targetXp = getXpForLevel(targetLevel);
    return targetXp > currentXp ? targetXp - currentXp : 0;
  }
  
  // Calculate estimated time to reach goal
  static double getEstimatedHours(int xpNeeded, int xpPerHour) {
    if (xpPerHour <= 0) return 0;
    return xpNeeded / xpPerHour;
  }
  
  // Format XP with commas
  static String formatXp(int xp) {
    return xp.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
  
  // Format GP with K/M/B suffixes
  static String formatGp(int gp) {
    if (gp >= 1000000000) {
      return '${(gp / 1000000000).toStringAsFixed(1)}B';
    } else if (gp >= 1000000) {
      return '${(gp / 1000000).toStringAsFixed(1)}M';
    } else if (gp >= 1000) {
      return '${(gp / 1000).toStringAsFixed(1)}K';
    }
    return gp.toString();
  }
  
  // Format time in hours to human readable
  static String formatTime(double hours) {
    if (hours < 1) {
      final minutes = (hours * 60).round();
      return '$minutes minutes';
    } else if (hours < 24) {
      return '${hours.toStringAsFixed(1)} hours';
    } else {
      final days = (hours / 24).toStringAsFixed(1);
      return '$days days';
    }
  }
  
  // Get progress percentage
  static double getProgressPercentage(int currentXp, int targetLevel) {
    final currentLevel = getLevelFromXp(currentXp);
    if (currentLevel >= targetLevel) return 100.0;
    
    final levelStartXp = getXpForLevel(currentLevel);
    final levelEndXp = getXpForLevel(targetLevel);
    final xpInLevel = currentXp - levelStartXp;
    final totalXpNeeded = levelEndXp - levelStartXp;
    
    return (xpInLevel / totalXpNeeded) * 100;
  }
}

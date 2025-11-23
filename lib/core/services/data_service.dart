import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quest.dart';
import '../models/skill.dart';
import '../models/money_method.dart';
import '../models/ge_item.dart';

class DataService {
  // Load quests from JSON
  Future<List<Quest>> loadQuests() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/quests.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Quest.fromJson(json)).toList();
    } catch (e) {
      print('Error loading quests: $e');
      return [];
    }
  }

  // Load skills from JSON
  Future<List<Skill>> loadSkills() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/skills.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Skill.fromJson(json)).toList();
    } catch (e) {
      print('Error loading skills: $e');
      return [];
    }
  }

  // Load money-making methods from JSON
  Future<List<MoneyMethod>> loadMoneyMethods() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/methods.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => MoneyMethod.fromJson(json)).toList();
    } catch (e) {
      print('Error loading money methods: $e');
      return [];
    }
  }

  // Load GE items from JSON
  Future<List<GeItem>> loadGeItems() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/json/items.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => GeItem.fromJson(json)).toList();
    } catch (e) {
      print('Error loading GE items: $e');
      return [];
    }
  }

  // Get quest by ID
  Future<Quest?> getQuestById(String id) async {
    final quests = await loadQuests();
    try {
      return quests.firstWhere((quest) => quest.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get skill by ID
  Future<Skill?> getSkillById(String id) async {
    final skills = await loadSkills();
    try {
      return skills.firstWhere((skill) => skill.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get money method by ID
  Future<MoneyMethod?> getMoneyMethodById(String id) async {
    final methods = await loadMoneyMethods();
    try {
      return methods.firstWhere((method) => method.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get GE item by ID
  Future<GeItem?> getGeItemById(int id) async {
    final items = await loadGeItems();
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_service.dart';

class FavoritesService {
  static const _kLocalKey = 'favorite_meals';

  static Future<void> saveLocalFavorite(Map<String, dynamic> meal) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kLocalKey) ?? [];
    list.add(jsonEncode(meal));
    await prefs.setStringList(_kLocalKey, list);
  }

  static Future<List<Map<String, dynamic>>> getLocalFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kLocalKey) ?? [];
    return list.map((s) => Map<String, dynamic>.from(jsonDecode(s))).toList();
  }

  static Future<void> addToFirestore(Map<String, dynamic> meal) async {
    await FirebaseService.addFavorite(meal);
  }
}

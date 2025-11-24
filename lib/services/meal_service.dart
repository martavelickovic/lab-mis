import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class MealService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  
  static Future<List<Category>> getCategories() async {
    final resp = await http.get(Uri.parse('${baseUrl}categories.php'));
    if (resp.statusCode != 200) throw Exception('Failed to load categories');
    final data = jsonDecode(resp.body);
    final list = (data['categories'] as List)
        .map((e) => Category.fromJson(e))
        .toList();
    return List<Category>.from(list);
  }

  
  static Future<List<Map<String, String>>> getMealsByCategory(String category) async {
    final resp = await http.get(Uri.parse('${baseUrl}filter.php?c=$category'));
    if (resp.statusCode != 200) throw Exception('Failed to load meals');
    final data = jsonDecode(resp.body);
    if (data['meals'] == null) return [];
    
    return (data['meals'] as List).map((e) {
      final map = e as Map<String, dynamic>;
      return {
        'id': map['idMeal']?.toString() ?? '',
        'name': map['strMeal']?.toString() ?? '',
        'image': map['strMealThumb']?.toString() ?? '',
      };
    }).toList();
  }

  
  static Future<List<Map<String, String>>> searchMeals(String query) async {
    final resp = await http.get(Uri.parse('${baseUrl}search.php?s=$query'));
    if (resp.statusCode != 200) throw Exception('Search failed');
    final data = jsonDecode(resp.body);
    if (data['meals'] == null) return [];

    return (data['meals'] as List).map((e) {
      final map = e as Map<String, dynamic>;
      return {
        'id': map['idMeal']?.toString() ?? '',
        'name': map['strMeal']?.toString() ?? '',
        'image': map['strMealThumb']?.toString() ?? '',
      };
    }).toList();
  }

  
  static Future<Meal> getMealById(String id) async {
    final resp = await http.get(Uri.parse('${baseUrl}lookup.php?i=$id'));
    if (resp.statusCode != 200) throw Exception('Failed to load meal');
    final data = jsonDecode(resp.body);
    final json = data['meals'][0] as Map<String, dynamic>;
    return Meal.fromJson(json);
  }

  
  static Future<Meal> getRandomMeal() async {
    final resp = await http.get(Uri.parse('${baseUrl}random.php'));
    if (resp.statusCode != 200) throw Exception('Failed to load random meal');
    final data = jsonDecode(resp.body);
    final json = data['meals'][0] as Map<String, dynamic>;
    return Meal.fromJson(json);
  }
}

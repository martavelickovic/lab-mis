import 'package:flutter/material.dart';
import '../services/meal_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'meals_screen.dart';
import 'meal_detail_screen.dart';
import '../models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];
  List<Category> _filtered = [];
  bool _loading = true;
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _loading = true);
    try {
      final cats = await MealService.getCategories();
      setState(() {
        _categories = cats;
        _filtered = cats;
      });
    } catch (e) {
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSearch(String q) {
    setState(() {
      if (q.trim().isEmpty) {
        _filtered = _categories;
      } else {
        _filtered = _categories.where((c) => c.name.toLowerCase().contains(q.toLowerCase())).toList();
      }
    });
  }

  Future<void> _showRandom() async {
    try {
      final Meal meal = await MealService.getRandomMeal();
      if (!mounted) return;
      Navigator.pushNamed(context, MealDetailScreen.routeName, arguments: meal);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Random failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: _showRandom,
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random recipe',
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCategories,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _search,
                      onChanged: _onSearch,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search categories',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final cat = _filtered[index];
                        return CategoryCard(
                          category: cat,
                          onTap: () {
                            Navigator.pushNamed(context, MealsScreen.routeName, arguments: cat.name);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

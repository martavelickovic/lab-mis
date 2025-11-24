import 'package:flutter/material.dart';
import '../services/meal_service.dart';
import '../widgets/meal_item.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  static const routeName = '/meals';
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<Map<String, String>> _meals = [];
  List<Map<String, String>> _filtered = [];
  bool _loading = true;
  final TextEditingController _search = TextEditingController();
  String _category = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg is String) {
      _category = arg;
      _loadMeals();
    }
  }

  Future<void> _loadMeals() async {
    setState(() => _loading = true);
    try {
      final list = await MealService.getMealsByCategory(_category);
      setState(() {
        _meals = list;
        _filtered = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading meals: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSearch(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _filtered = _meals);
      return;
    }
    
    setState(() => _loading = true);
    try {
      final results = await MealService.searchMeals(q);
      
      final idsInCategory = _meals.map((m) => m['id']).toSet();
      final filtered = results.where((r) => idsInCategory.contains(r['id'])).toList();
      setState(() => _filtered = filtered);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals — $_category'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _search,
                    onChanged: _onSearch,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search meals in this category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final meal = _filtered[index];
                      return MealItem(
                        id: meal['id'] ?? '',
                        title: meal['name'] ?? '',
                        image: meal['image'] ?? '',
                        onTap: () async {
                          
                          final id = meal['id'] ?? '';
                          try {
                            final full = await MealService.getMealById(id);
                            if (!mounted) return;
                            Navigator.pushNamed(context, MealDetailScreen.routeName, arguments: full);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

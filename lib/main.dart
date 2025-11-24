import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';
import 'screens/meals_screen.dart';
import 'screens/meal_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CategoriesScreen(),
        MealsScreen.routeName: (context) => const MealsScreen(),
        MealDetailScreen.routeName: (context) => const MealDetailScreen(),
      },
    );
  }
}

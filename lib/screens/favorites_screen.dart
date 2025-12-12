import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../services/meal_service.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.favoritesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No favorites yet'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return ListTile(
                leading: data['image'] != null ? Image.network(data['image'], width: 56, fit: BoxFit.cover) : null,
                title: Text(data['title'] ?? ''),
                subtitle: Text(data['addedAt'] ?? ''),
                onTap: () async {
                  if (data['id'] != null) {
                    final fullMeal = await MealService.getMealById(data['id']);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailScreen(meal: fullMeal)));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

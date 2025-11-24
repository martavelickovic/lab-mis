import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';
  const MealDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meal')),
        body: const Center(child: Text('No meal provided')),
      );
    }

    
    final Meal meal = args is Meal ? args : throw Exception('Expected Meal');

    return Scaffold(
      appBar: AppBar(title: Text(meal.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            if (meal.image.isNotEmpty)
              Center(
                child: Image.network(
                  meal.image,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, size: 80),
                ),
              ),
            const SizedBox(height: 12),
            
            const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...meal.ingredients.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text('${e.key} — ${e.value}'),
              );
            }),
            const SizedBox(height: 12),
            
            const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(meal.instructions),
            const SizedBox(height: 12),
            
           if (meal.youtube.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(meal.youtube); 

                if (await canLaunchUrl(uri)) {
                  await launchUrl(
                     uri,
                    mode: LaunchMode.externalApplication, 
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Could not open link')),
                  );
                }
              },

              icon: const Icon(Icons.play_circle_fill),
              label: const Text("Recipe Video"),
            ),

          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                category.thumb,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                category.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                category.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

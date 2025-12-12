// import 'package:flutter/material.dart';
//
// class MealItem extends StatelessWidget {
//   final String id;
//   final String title;
//   final String image;
//   final VoidCallback onTap;
//
//   const MealItem({
//     super.key,
//     required this.id,
//     required this.title,
//     required this.image,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         elevation: 2,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Image.network(
//                 image,
//                 fit: BoxFit.cover,
//                 errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image_not_supported)),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../services/favorites_service.dart';

class MealItem extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  final VoidCallback onTap;

  const MealItem({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () async {
                    final fav = {
                      'id': id,
                      'title': title,
                      'image': image,
                      'addedAt': DateTime.now().toIso8601String(),
                    };
                    await FavoritesService.saveLocalFavorite(fav);
                    await FavoritesService.addToFirestore(fav);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to favorites')));
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


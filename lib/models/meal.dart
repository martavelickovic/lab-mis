class Meal {
  final String id;
  final String name;
  final String image;
  final String instructions;
  final Map<String, String> ingredients; // ingredient -> measure
  final String youtube;

  Meal({
    required this.id,
    required this.name,
    required this.image,
    required this.instructions,
    required this.ingredients,
    required this.youtube,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final Map<String, String> ing = {};
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ing[ingredient.toString()] = (measure ?? '').toString();
      }
    }

    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      image: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ing,
      youtube: json['strYoutube'] ?? '',
    );
  }
}

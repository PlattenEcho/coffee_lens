class Ingredient {
  final String name;
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });
}

class Recipe {
  final String title;
  final String category;
  final String description;
  final String duration;
  final double rating;
  final String imageUrl;
  final List<String> tools;
  final List<Ingredient> ingredients;
  final List<String> steps;

  Recipe({
    required this.title,
    required this.category,
    required this.description,
    required this.duration,
    required this.rating,
    required this.imageUrl,
    required this.tools,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] ?? 'No title',
      category: json['category'] ?? 'Uncategorized',
      description: json['description'] ?? '',
      duration: json['waktu']?.toString() ?? '0',
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['img_url'] ?? 'assets/onboarding1.jpg',
      tools: json['alat'] != null
          ? List<String>.from(json['alat'].map((tool) => tool['name'] ?? ''))
          : [],
      ingredients: json['bahan'] != null
          ? List<Ingredient>.from(
              json['bahan'].map((ingredient) => Ingredient(
                    name: ingredient['name'] ?? 'Unknown',
                    quantity: ingredient['kuantitas'] ?? '0',
                  )),
            )
          : [],
      steps: json['langkah'] != null
          ? List<String>.from(
              json['langkah'].map((step) => step['langkah'] ?? ''))
          : [],
    );
  }
}

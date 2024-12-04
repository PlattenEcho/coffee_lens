class Ingredient {
  final String name;
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });
}

class Recipe {
  final int id;
  final int idUser;
  final String title;
  final String category;
  final String description;
  final String duration;
  double rating;
  final String imageUrl;
  final List<String> tools;
  final List<Ingredient> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.idUser,
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
      id: json['id'] ?? 0,
      idUser: json['id_user'] ?? 0,
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

  Recipe copyWith({
    int? id,
    int? idUser,
    String? title,
    String? category,
    String? description,
    String? duration,
    double? rating,
    String? imageUrl,
    List<String>? tools,
    List<Ingredient>? ingredients,
    List<String>? steps,
  }) {
    return Recipe(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      tools: tools ?? this.tools,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }
}

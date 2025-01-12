class Rating {
  final int id;
  final int idResep;
  final int idUser;
  final double rating;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.idResep,
    required this.idUser,
    required this.rating,
    required this.createdAt,
  });

  Rating.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        idResep = map['id_resep'] ?? '',
        idUser = map['id_user'] ?? '',
        rating = map['rating'] ?? '',
        createdAt = DateTime.tryParse(map['created_at']) ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_resep': idResep,
      'id_user': idUser,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

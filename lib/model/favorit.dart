class Favorit {
  final int id;
  final int idResep;
  final int idUser;
  final DateTime createdAt;

  Favorit({
    required this.id,
    required this.idResep,
    required this.idUser,
    required this.createdAt,
  });

  Favorit.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        idResep = map['id_resep'] ?? '',
        idUser = map['id_user'] ?? '',
        createdAt = DateTime.tryParse(map['created_at']) ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_resep': idResep,
      'id_user': idUser,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Alat {
  final int id;
  final int idResep;
  final String name;
  final DateTime createdAt;

  Alat({
    required this.id,
    required this.idResep,
    required this.name,
    required this.createdAt,
  });

  Alat.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        idResep = map['id_resep'] ?? '',
        name = map['name'] ?? '',
        createdAt = DateTime.tryParse(map['created_at']) ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_resep': idResep,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

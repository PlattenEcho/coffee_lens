class Langkah {
  final int id;
  final int idResep;
  final String name;
  final String kuantitas;
  final DateTime createdAt;

  Langkah({
    required this.id,
    required this.idResep,
    required this.name,
    required this.kuantitas,
    required this.createdAt,
  });

  Langkah.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        idResep = map['id_resep'] ?? '',
        name = map['name'] ?? '',
        kuantitas = map['kuantitas'] ?? '',
        createdAt = DateTime.tryParse(map['created_at']) ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_resep': idResep,
      'name': name,
      'kuantitas': kuantitas,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

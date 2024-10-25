class User {
  final int id;
  final String email;
  final String username;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        username = map['username'] ?? '',
        createdAt = DateTime.tryParse(map['created_at']) ?? DateTime.now(),
        email = map['email'] ?? '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'created_at': createdAt.toIso8601String(),
      'email': email,
    };
  }
}

class User {
  final int id;
  final String email;
  final String username;
  final DateTime createdAt;
  final String description;
  final String imgUrl;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.createdAt,
      required this.description,
      required this.imgUrl});

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        username = map['username'] ?? '',
        createdAt = DateTime.tryParse(map['created_at']) ?? DateTime.now(),
        email = map['email'] ?? '',
        description = map['deskripsi'] ?? '',
        imgUrl = map['img_url'] ?? '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'created_at': createdAt.toIso8601String(),
      'email': email,
      'deskripsi': description,
      'img_url': imgUrl
    };
  }
}

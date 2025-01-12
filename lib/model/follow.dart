class Follow {
  final int id;
  final int idFollowing;
  final int idFollower;
  final DateTime createdAt;

  Follow({
    required this.id,
    required this.idFollowing,
    required this.idFollower,
    required this.createdAt,
  });

  Follow.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        idFollowing = map['id_following'] ?? '',
        idFollower = map['id_follower'] ?? '',
        createdAt = DateTime.tryParse(map['created_at']) ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_following': idFollowing,
      'id_follower': idFollower,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

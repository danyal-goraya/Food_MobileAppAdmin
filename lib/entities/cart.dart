class CartEntity {
  final String id;
  final String userId;
  final DateTime createdAt;

  CartEntity({required this.id, required this.userId, required this.createdAt});

  factory CartEntity.fromJson(Map<String, dynamic> json) {
    return CartEntity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

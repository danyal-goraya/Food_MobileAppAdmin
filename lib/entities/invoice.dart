class InvoiceEntity {
  final String id;
  final String orderId;
  final double totalAmount;
  // Rename this to generatedAt to match your UI and DB logic
  final DateTime generatedAt;

  InvoiceEntity({
    required this.id,
    required this.orderId,
    required this.totalAmount,
    required this.generatedAt,
  });

  factory InvoiceEntity.fromJson(Map<String, dynamic> json) {
    return InvoiceEntity(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      // Use the 'generated_at' key from Supabase
      generatedAt: json['generated_at'] != null
          ? DateTime.parse(json['generated_at'] as String)
          : DateTime.now(),
    );
  }

  // REMOVE THE OLD GETTER: DateTime? get generatedAt => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'total_amount': totalAmount,
      'generated_at': generatedAt.toIso8601String(),
    };
  }
}

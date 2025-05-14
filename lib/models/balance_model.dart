class Balance {
  final int totalIngresos;
  final int totalEgresos;
  final int balance;

  Balance({
    required this.totalIngresos,
    required this.totalEgresos,
    required this.balance,
  });

  // Convertir JSON a objeto Dart
  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      totalIngresos: json["total_ingresos"] ?? 0,
      totalEgresos: json["total_egresos"] ?? 0,
      balance: json["balance"] ?? 0,
    );
  }
}

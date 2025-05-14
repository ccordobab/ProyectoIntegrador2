class Propietario {
  final int id;
  final String name;
  final String propertyId;
  final String? phone;
  final String? email;
  final int userId;

  Propietario({
    required this.id,
    required this.name,
    required this.userId,
    required this.propertyId,
    this.phone,
    this.email,
  });

  // Convertir JSON a objeto Dart
  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['id'],
      propertyId: json['propertyId'],
      name: json['user']['name'],
      phone: json['user']['phone'],
      email: json['user']['email'],
      userId: json['user']['id'],
    );
  }
}

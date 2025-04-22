class Excusa {
  final int id;
  final String name;
  final int employeeId;
  final String description;
  final String fromDate;
  final String toDate;

  Excusa({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.description,
    required this.fromDate,
    required this.toDate,
  });

  // Convertir JSON a objeto Dart
  factory Excusa.fromJson(Map<String, dynamic> json) {
    return Excusa(
      id: json['id'],
      name: json['name'],
      employeeId: json['employee'],
      description: json['description'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
    );
  }
}

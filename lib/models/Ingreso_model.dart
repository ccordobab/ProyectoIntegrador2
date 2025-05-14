class Ingreso {
  final int id;
  final int cantidad;
  final String descripcion;
  final String fecha;
  final String origen;

  Ingreso({
    required this.id,
    required this.cantidad,
    required this.descripcion,
    required this.fecha,
    required this.origen,
  });

  // Convertir JSON a objeto Dart
  factory Ingreso.fromJson(Map<String, dynamic> json) {
    return Ingreso(
      cantidad: json['cantidad'],
      id: json['id'],
      fecha: json['fecha'],
      descripcion: json['descripcion'],
      origen: json['origen'],
    );
  }
}

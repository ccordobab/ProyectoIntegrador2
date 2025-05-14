class Egreso {
  final int id;
  final String descripcion;
  final String destino;
  final int cantidad;
  final String fecha;

  Egreso({
    required this.id,
    required this.descripcion,
    required this.destino,
    required this.cantidad,
    required this.fecha,
  });

  // Convertir JSON a objeto Dart
  factory Egreso.fromJson(Map<String, dynamic> json) {
    return Egreso(
        id: json['id'],
        cantidad: json['cantidad'],
        fecha: json['fecha'],
        descripcion: json['descripcion'],
        destino: json['destino']);
  }
}

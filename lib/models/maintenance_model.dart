class Maintenance {
  final int id;
  final String nombre;
  final String lugar;
  final String fecha;
  final String tipo;
  final bool completado;
  final String descripcion;

  Maintenance({
    required this.id,
    required this.nombre,
    required this.lugar,
    required this.fecha,
    required this.tipo,
    required this.completado,
    required this.descripcion,
  });

  // Convertir JSON a objeto Dart
  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'],
      nombre: json['name'],
      lugar: json['place'],
      fecha: json['date'],
      tipo: json['maintenanceType'],
      completado: json['completed'],
      descripcion: json['description'],
    );
  }
}

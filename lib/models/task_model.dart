class Task {
  final int id;
  final String nombre;
  final String fecha;
  final String lugar;
  final String estado;
  final int persona;

  Task({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.lugar,
    required this.estado,
    required this.persona,
  });

  // Convertir JSON a objeto Dart
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      lugar: json['place'],
      fecha: json['time'],
      nombre: json['name'],
      estado: json['state'],
      persona: json['employee'],
    );
  }
}

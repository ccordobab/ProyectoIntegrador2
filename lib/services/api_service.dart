import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000/api/";

  Future<List<dynamic>> fetchEmployees() async {
    final response = await http.get(Uri.parse("${baseUrl}employees/"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener los usuarios");
    }
  }

  Future<List<dynamic>> fetchTasksByEmployee(int employeeId) async {
    final response =
        await http.get(Uri.parse("${baseUrl}tasks/employee/$employeeId/"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener tareas del empleado");
    }
  }

  Future<List<dynamic>> fetchExcusasByEmployee(int employeeId) async {
    final response =
        await http.get(Uri.parse("${baseUrl}excusa/employee/$employeeId/"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener excusas del empleado");
    }
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    final url = Uri.parse(
        "${baseUrl}tareas/"); // Asegúrate de tener esta ruta en Django
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear la tarea");
    }
  }

  Future<void> createExcusa(Map<String, dynamic> taskData) async {
    final url = Uri.parse(
        "${baseUrl}excusas/"); // Asegúrate de tener esta ruta en Django
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear la Excusa");
    }
  }

  Future<List<dynamic>> fetchMaintenances({required bool completed}) async {
    final response = await http
        .get(Uri.parse("${baseUrl}maintenances/?completed=$completed"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener los mantenimientos");
    }
  }

  Future<void> createMaintenance(Map<String, dynamic> taskData) async {
    final url = Uri.parse(
        "${baseUrl}maintenances/"); // Asegúrate de tener esta ruta en Django
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear manteniminto");
    }
  }

  // api_service.dart
  Future<void> markAsCompleted(int id) async {
    final response = await http.patch(
      Uri.parse("${baseUrl}maintenances/$id/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"completed": true}),
    );

    if (response.statusCode != 200) {
      throw Exception("No se pudo marcar como completado");
    }
  }

  Future<void> markAsUncompleted(int id) async {
    final response = await http.patch(
      Uri.parse("${baseUrl}maintenances/$id/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"completed": false}),
    );

    if (response.statusCode != 200) {
      throw Exception("No se pudo marcar como incompletado");
    }
  }
}

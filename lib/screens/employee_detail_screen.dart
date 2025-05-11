import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:domus/models/employee_model.dart';
import 'package:domus/models/excusa_model.dart';
import 'package:domus/models/task_model.dart';
import 'package:domus/widgets/Excusa_card.dart';
import 'package:domus/widgets/employee_detail_card.dart';
import 'package:domus/widgets/tarea_card.dart';
import 'package:domus/services/api_service.dart'; // IMPORTANTE

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;

  EmployeeDetailScreen({required this.employee});

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Task>> _futureTareas;
  late Future<List<Excusa>> _futureExcusas;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _futureTareas = _fetchTareasDesdeAPI();
    _futureExcusas = _fetchExcusasDesdeAPI();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Task>> _fetchTareasDesdeAPI() async {
    ApiService apiService = ApiService();
    final data = await apiService.fetchTasksByEmployee(widget.employee.id);
    return data.map<Task>((json) => Task.fromJson(json)).toList();
  }

  Future<List<Excusa>> _fetchExcusasDesdeAPI() async {
    ApiService apiService = ApiService();
    final data = await apiService.fetchExcusasByEmployee(widget.employee.id);
    return data.map<Excusa>((json) => Excusa.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee.name,
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          dividerColor: Colors.lightGreen,
          labelStyle: GoogleFonts.lato(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
          tabs: [
            Tab(text: 'Información'),
            Tab(text: 'Tareas'),
            Tab(text: 'Excusas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInformacionTab(),
          _buildTareasTab(),
          _buildExcusasTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: _mostrarFormularioTarea,
              backgroundColor: Colors.greenAccent,
              child: Icon(Icons.add, color: Colors.white),
            )
          : _tabController.index == 2
              ? FloatingActionButton(
                  onPressed: _mostrarFormularioExcusa,
                  backgroundColor: Colors.lightGreen,
                  child: const Icon(Icons.note_add, color: Colors.white),
                )
              : null,
    );
  }

  Widget _buildInformacionTab() {
    return EmployeeDetailCard(employee: widget.employee);
  }

  Widget _buildTareasTab() {
    return FutureBuilder<List<Task>>(
      future: _futureTareas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar tareas: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay tareas asignadas.'));
        } else {
          List<Task> tareas = snapshot.data!;
          return ListView.builder(
            itemCount: tareas.length,
            itemBuilder: (context, index) {
              return TareaCard(tarea: tareas[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildExcusasTab() {
    return FutureBuilder<List<Excusa>>(
      future: _futureExcusas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar excusas: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay excusas.'));
        } else {
          List<Excusa> excusas = snapshot.data!;
          return ListView.builder(
            itemCount: excusas.length,
            itemBuilder: (context, index) {
              return ExcusaCard(excusa: excusas[index]);
            },
          );
        }
      },
    );
  }

  void _mostrarFormularioTarea() {
    TextEditingController nombreController = TextEditingController();
    TextEditingController fechaController = TextEditingController();
    TextEditingController lugarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nueva Tarea",
              style:
                  GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: "Nombre de la tarea"),
              ),
              GestureDetector(
                onTap: () async {
                  // Primero muestra el calendario
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    // Luego muestra el selector de hora
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      // Combina fecha y hora
                      final combined = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      setState(() {
                        _selectedDateTime = combined;
                        fechaController.text = '${combined.toLocal()}'
                            .split('.')[0]; // Formato YYYY-MM-DD HH:MM
                      });
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: fechaController,
                    decoration: InputDecoration(
                      labelText: "Selecciona la fecha y hora",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              TextField(
                controller: lugarController,
                decoration: InputDecoration(labelText: "Lugar (nombre exacto)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final taskData = {
                    "name": nombreController.text,
                    "time": fechaController.text,
                    "state": "scheduled",
                    "employee": widget.employee.id,
                    "place": lugarController.text,
                  };

                  await ApiService().createTask(taskData);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Tarea creada con éxito")));

                  Navigator.pop(context);

                  setState(() {
                    _futureTareas = _fetchTareasDesdeAPI();
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al crear la tarea")));
                }
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  DateTime? _selectedDateTime;

  void _mostrarFormularioExcusa() {
    TextEditingController nombreController = TextEditingController();
    TextEditingController fechaInicialController = TextEditingController();
    TextEditingController fechaFinalController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nueva Excusa",
              style:
                  GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: "Nombre de la excusa"),
              ),
              GestureDetector(
                onTap: () async {
                  // Primero muestra el calendario
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    // Luego muestra el selector de hora
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      // Combina fecha y hora
                      final combined = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      setState(() {
                        _selectedDateTime = combined;
                        fechaInicialController.text = '${combined.toLocal()}'
                            .split('.')[0]; // Formato YYYY-MM-DD HH:MM
                      });
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: fechaInicialController,
                    decoration: InputDecoration(
                      labelText: "Selecciona la fecha y hora",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // Primero muestra el calendario
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    // Luego muestra el selector de hora
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      // Combina fecha y hora
                      final combined = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );

                      setState(() {
                        _selectedDateTime = combined;
                        fechaFinalController.text = '${combined.toLocal()}'
                            .split('.')[0]; // Formato YYYY-MM-DD HH:MM
                      });
                    }
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: fechaFinalController,
                    decoration: InputDecoration(
                      labelText: "Selecciona la fecha y hora",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: "Describa la excusa"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final taskData = {
                    "name": nombreController.text,
                    "fromDate": fechaInicialController.text,
                    "toDate": fechaFinalController.text,
                    "employee": widget.employee.id,
                    "description": descripcionController.text,
                  };

                  await ApiService().createExcusa(taskData);

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Excusa creada con éxito")));

                  Navigator.pop(context);
                  setState(() {
                    _futureExcusas = _fetchExcusasDesdeAPI();
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al crear la Excusa $e")));
                }
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}

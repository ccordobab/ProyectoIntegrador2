import 'package:domus/models/maintenance_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/mantenimiento_card.dart';
import 'package:domus/services/api_service.dart';

class MaintenanceScreen extends StatefulWidget {
  @override
  _MaintenanceScreenState createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Maintenance>> _futureMaintenancesPendientes;
  late Future<List<Maintenance>> _futureMaintenancesCompletas;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _futureMaintenancesPendientes = _fetchMaintenancesDesdeAPI(false);
    _futureMaintenancesCompletas = _fetchMaintenancesDesdeAPI(true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Maintenance>> _fetchMaintenancesDesdeAPI(bool completed) async {
    ApiService apiService = ApiService();
    final data = await apiService.fetchMaintenances(completed: completed);
    return data.map<Maintenance>((json) => Maintenance.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mantenimientos',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          dividerColor: Colors.lightGreen,
          labelStyle: GoogleFonts.lato(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
          tabs: [
            Tab(text: 'Pendientes'),
            Tab(text: 'Completados'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProgramadosTab(),
          _buildHistorialTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _mostrarFormularioMantenimiento,
              backgroundColor: Colors.greenAccent,
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildProgramadosTab() {
    return FutureBuilder<List<Maintenance>>(
      future: _futureMaintenancesPendientes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar Mantenimientos: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay Mantenimientos aqui.'));
        } else {
          List<Maintenance> mantenimientos = snapshot.data!;
          return ListView.builder(
            itemCount: mantenimientos.length,
            itemBuilder: (context, index) {
              return MantenimientoCard(mantenimiento: mantenimientos[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildHistorialTab() {
    return FutureBuilder<List<Maintenance>>(
      future: _futureMaintenancesCompletas,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar Mantenimientos: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay Mantenimientos aqui.'));
        } else {
          List<Maintenance> mantenimientos = snapshot.data!;
          return ListView.builder(
            itemCount: mantenimientos.length,
            itemBuilder: (context, index) {
              return MantenimientoCard(mantenimiento: mantenimientos[index]);
            },
          );
        }
      },
    );
  }

  void _mostrarFormularioMantenimiento() {
    TextEditingController nombreController = TextEditingController();
    TextEditingController fechaController = TextEditingController();
    TextEditingController lugarController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();
    TextEditingController tipoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nuevo Mantenimiento",
              style:
                  GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration:
                    InputDecoration(labelText: "Nombre del mantenimiento"),
              ),
              TextField(
                controller: fechaController,
                decoration:
                    InputDecoration(labelText: "Fecha (YYYY-MM-DD HH:MM)"),
              ),
              TextField(
                controller: lugarController,
                decoration: InputDecoration(labelText: "Lugar (nombre exacto)"),
              ),
              TextField(
                controller: descripcionController,
                decoration:
                    InputDecoration(labelText: "describa el mantenimiento"),
              ),
              TextField(
                controller: tipoController,
                decoration: InputDecoration(labelText: "tipo de mantenimiento"),
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
                    "date": fechaController.text,
                    "completed": false,
                    "description": descripcionController.text,
                    "place": lugarController.text,
                    "maintenanceType": tipoController.text,
                  };

                  await ApiService().createMaintenance(taskData);

                  setState(() {
                    _futureMaintenancesPendientes =
                        _fetchMaintenancesDesdeAPI(false);
                    _futureMaintenancesCompletas =
                        _fetchMaintenancesDesdeAPI(true);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Mantenimiento creado con éxito")));

                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Error al crear mantenimiento ${e}")));
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

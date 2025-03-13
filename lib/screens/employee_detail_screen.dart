import 'package:domus/models/employee_model.dart';
import 'package:domus/models/excusa_model.dart';
import 'package:domus/models/tarea_model.dart';
import 'package:domus/widgets/Excusa_card.dart';
import 'package:domus/widgets/employee_detail_card.dart';
import 'package:domus/widgets/tarea_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;

  EmployeeDetailScreen({required this.employee});

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee.name, style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          dividerColor: Colors.lightGreen,
          labelStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
          tabs: [
            Tab(text: 'Informacion'),
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
    );
  }

  Widget _buildInformacionTab() {
    return EmployeeDetailCard(employee: widget.employee);
  }

  Widget _buildTareasTab() {
    List<Tarea> tareas = [
      Tarea(id: 1, nombre: 'verificar seguridad', fecha: '12/05/2025', lugar: 'sendero', estado: 'pendiente', persona: 'lolita')
    ];

    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (context, index) {
        return TareaCard(tarea: tareas[index]);
      },
    );
  }


  Widget _buildExcusasTab() {
    List<Excusa> excusas = [
      Excusa(id: 1, name: 'Incapacidad', employee: Employee(id: 4, name: 'katy', role: 'Salva vidas'), description: 'Tengo gripa')
    ];

    return ListView.builder(
      itemCount: excusas.length,
      itemBuilder: (context, index) {
        return ExcusaCard(excusa: excusas[index]);
      },
    );
  }
}
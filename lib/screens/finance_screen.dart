import 'package:domus/models/Ingreso_model.dart';
import 'package:domus/models/egreso_model.dart';
import 'package:domus/screens/egreso_detail_screen.dart';
import 'package:domus/widgets/ingreso_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/mantenimiento_card.dart';
import 'package:domus/services/api_service.dart';
import 'package:domus/screens/Ingreso_detail_screen.dart';
import 'package:domus/widgets/egreso_card.dart';
import 'package:domus/models/balance_model.dart';
import 'package:domus/widgets/balance_card.dart';

class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Ingreso>> _futureIngresos;
  late Future<List<Egreso>> _futureEgresos;
  late Future<Balance> _futureBalance;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _futureIngresos = _fetchIngresosDesdeAPI();
    _futureEgresos = _fetchEgresosDesdeAPI();
    _futureBalance = _fetchBalanceDesdeAPI();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Ingreso>> _fetchIngresosDesdeAPI() async {
    ApiService apiService = ApiService();
    final data = await apiService.fetchIngresos();
    return data.map<Ingreso>((json) => Ingreso.fromJson(json)).toList();
  }

  Future<List<Egreso>> _fetchEgresosDesdeAPI() async {
    ApiService apiService = ApiService();
    final data = await apiService.fetchEgresos();
    return data.map<Egreso>((json) => Egreso.fromJson(json)).toList();
  }

  Future<Balance> _fetchBalanceDesdeAPI() async {
    ApiService apiService = ApiService();
    final json = await apiService.fetchBalance();
    return Balance.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanzas',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.green,
          dividerColor: Colors.lightGreen,
          labelStyle: GoogleFonts.lato(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
          tabs: [
            Tab(text: 'Ingresos'),
            Tab(text: 'Egresos'),
            Tab(text: 'Balance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildIngresosTab(),
          _buildEgresosTab(),
          _buildBalanceTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: _mostrarFormularioEgreso,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildIngresosTab() {
    return FutureBuilder<List<Ingreso>>(
      future: _futureIngresos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar ingresitos: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay nada de ingresos aqui.'));
        } else {
          List<Ingreso> ingresos = snapshot.data!;
          return ListView.builder(
            itemCount: ingresos.length,
            itemBuilder: (context, index) {
              Ingreso ingreso = ingresos[index];

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IngresoDetailScreen(
                          ingreso: ingreso,
                        ),
                      ),
                    );
                  },
                  child: IngresoCard(
                    ingreso: ingreso,
                  )).animate().fade(duration: 500.ms).slideY();
            },
          );
        }
      },
    );
  }

  Widget _buildEgresosTab() {
    return FutureBuilder<List<Egreso>>(
      future: _futureEgresos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar ingresitos: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay nada de egresos aqui.'));
        } else {
          List<Egreso> egresos = snapshot.data!;
          return ListView.builder(
            itemCount: egresos.length,
            itemBuilder: (context, index) {
              Egreso egreso = egresos[index];

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EgresoDetailScreen(
                          egreso: egreso,
                        ),
                      ),
                    );
                  },
                  child: EgresoCard(
                    egreso: egreso,
                  )).animate().fade(duration: 500.ms).slideY();
            },
          );
        }
      },
    );
  }

  Widget _buildBalanceTab() {
    return FutureBuilder<Balance>(
      future: _futureBalance,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error al cargar balance: ${snapshot.error}'));
        } else {
          return BalanceCard(balance: snapshot.data!);
        }
      },
    );
  }

  DateTime? _selectedDateTime;

  void _mostrarFormularioEgreso() {
    TextEditingController cantidadController = TextEditingController();
    TextEditingController fechaController = TextEditingController();
    TextEditingController destinoController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nuevo Egreso",
              style:
                  GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cantidadController,
                decoration: InputDecoration(labelText: "Cuanto gataremos?"),
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
                controller: destinoController,
                decoration: InputDecoration(labelText: "Destino"),
              ),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: "describa el gasto"),
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
                    "cantidad": int.parse(cantidadController.text),
                    "fecha": fechaController.text,
                    "destino": destinoController.text,
                    "descripcion": descripcionController.text,
                  };

                  await ApiService().createEgreso(taskData);

                  setState(() {
                    _futureEgresos = _fetchEgresosDesdeAPI();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Egreso creado con éxito")));

                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error al gastar ${e}")));
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

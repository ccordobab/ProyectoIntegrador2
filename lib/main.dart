import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/personnel_screen.dart';
import 'screens/finance_screen.dart';
import 'screens/reservations_screen.dart';
import 'screens/maintenance_screen.dart';

void main() {
  runApp(DomusApp());
}

class DomusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Domus',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/personnel': (context) => PersonnelScreen(),
        '/finances': (context) => FinanceScreen(),
        '/reservations': (context) => ReservationsScreen(),
        '/mantenimientos': (context) => MaintenanceScreen(),
      },
    );
  }
}


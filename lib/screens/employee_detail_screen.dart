import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;

  EmployeeDetailScreen({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle empleado',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${employee.name}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Rol: ${employee.role}", style: TextStyle(fontSize: 15)),
              Text("Id: ${employee.id}", style: TextStyle(fontSize: 15)),
              if (employee.phone != null)
                Text("Phone: ${employee.phone}",
                    style: TextStyle(fontSize: 15)),
              if (employee.email != null)
                Text("Email: ${employee.email}",
                    style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

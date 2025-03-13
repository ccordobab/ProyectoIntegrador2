import 'package:domus/models/employee_model.dart';
import 'package:domus/widgets/employee_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../screens/employee_detail_screen.dart';

class EmployeeScreen extends StatelessWidget {
  final List<Employee> employees = [
    Employee(id: 1, name: 'Jordan', role: 'Portero'),
    Employee(id: 2, name: 'Lolita', role: 'Rondera'),
    Employee(id: 3, name: 'Stiven', role: 'Servicios generales')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Personal',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];

            return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeDetailScreen(
                            employee: employee,
                          ),
                        ),
                      );
                    },
                    child: EmployeeCard(employee: employee))
                .animate()
                .fade(duration: 500.ms)
                .slideY();
          },
        ),
      ),
    );
  }
}

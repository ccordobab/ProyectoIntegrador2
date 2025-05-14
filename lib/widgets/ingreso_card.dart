import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/Ingreso_model.dart';

class IngresoCard extends StatelessWidget {
  final Ingreso ingreso;

  const IngresoCard({Key? key, required this.ingreso}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.green[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.attach_money, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              ingreso.cantidad.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

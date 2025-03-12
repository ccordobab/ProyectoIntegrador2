import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tarea_model.dart';
import '../screens/tarea_detalle_screen.dart';

class TareaCard extends StatelessWidget {
  final Tarea tarea;

  const TareaCard({Key? key, required this.tarea}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(tarea.nombre, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text("Fecha: ${tarea.fecha}", style: GoogleFonts.lato(fontSize: 14)),
        trailing: Text(tarea.persona, style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TareaDetalleScreen(tarea: tarea),
            ),
          );
        },
      ),
    );
  }
}

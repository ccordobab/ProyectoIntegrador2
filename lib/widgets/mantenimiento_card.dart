import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/maintenance_model.dart';
import '../services/api_service.dart';

class MantenimientoCard extends StatefulWidget {
  final Maintenance mantenimiento;
  final VoidCallback? onUpdate;

  const MantenimientoCard(
      {Key? key, required this.mantenimiento, this.onUpdate})
      : super(key: key);

  @override
  _MantenimientoCardState createState() => _MantenimientoCardState();
}

class _MantenimientoCardState extends State<MantenimientoCard> {
  late bool _completado;

  @override
  void initState() {
    super.initState();
    _completado = widget.mantenimiento.completado;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.mantenimiento.nombre,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
              Divider(color: Colors.grey[300]),
              _buildInfoRow(Icons.person, "Descripción",
                  widget.mantenimiento.descripcion),
              _buildInfoRow(
                  Icons.calendar_today, "Fecha", widget.mantenimiento.fecha),
              _buildInfoRow(
                  Icons.calendar_today, "Tipo", widget.mantenimiento.tipo),
              _buildInfoRow(Icons.numbers, "¿Está completado?",
                  widget.mantenimiento.completado.toString()),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    icon: Icons.check,
                    label: "Aceptar",
                    color: Colors.green,
                    onPressed: () async {
                      await ApiService()
                          .markAsCompleted(widget.mantenimiento.id);
                      print("Excusa aceptada");
                      setState(() {
                        _completado = true;
                      });
                      widget.onUpdate?.call();
                    },
                  ),
                  _buildButton(
                    icon: Icons.close,
                    label: "Rechazar",
                    color: Colors.red,
                    onPressed: () async {
                      await ApiService()
                          .markAsUncompleted(widget.mantenimiento.id);
                      print("Excusa rechazada");
                      setState(() {
                        _completado = false;
                      });
                      widget.onUpdate?.call();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[700], size: 20),
          SizedBox(width: 10),
          Text(
            "$label:",
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label,
          style:
              GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
      onPressed: onPressed,
    );
  }
}

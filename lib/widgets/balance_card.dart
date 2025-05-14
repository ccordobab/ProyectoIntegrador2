import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/balance_model.dart';

class BalanceCard extends StatelessWidget {
  final Balance balance;

  BalanceCard({required this.balance});

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
                "Detalle del Balance",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
              Divider(color: Colors.grey[300]),
              _buildInfoRow(Icons.attach_money_rounded, "TOTAL DEL BALANCE",
                  balance.balance.toString()),
              _buildInfoRow(Icons.arrow_circle_up, "Total de Ingresos",
                  balance.totalIngresos.toString()),
              _buildInfoRow(Icons.arrow_circle_down_outlined,
                  "Total de Egresos", balance.totalEgresos.toString()),
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
}

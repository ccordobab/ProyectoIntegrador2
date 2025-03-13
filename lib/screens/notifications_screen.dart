import 'package:domus/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notificaciones')),
      body: Center(child: Text('Tus Notificaiones')),
      bottomNavigationBar: BottomNavigationBarCard(currentIndex: 1),
    );
  }
}

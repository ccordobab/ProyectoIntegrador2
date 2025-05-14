import 'package:domus/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Perfil"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Nombre y rol
              const Text(
                "Diana Martínez",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Administradora General",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Información de contacto
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      InfoRow(
                          icon: Icons.email,
                          label: "Correo",
                          value: "admin@domus.com"),
                      Divider(),
                      InfoRow(
                          icon: Icons.phone,
                          label: "Teléfono",
                          value: "+57 301 456 7890"),
                      Divider(),
                      InfoRow(
                          icon: Icons.location_on,
                          label: "Ubicación",
                          value: "Medellín, Colombia"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Configuraciones
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Column(
                  children: const [
                    SettingTile(icon: Icons.lock, title: "Cambiar contraseña"),
                    SettingTile(
                        icon: Icons.notifications, title: "Notificaciones"),
                    SettingTile(icon: Icons.language, title: "Idioma"),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botón de cerrar sesión
              ElevatedButton.icon(
                onPressed: () {
                  // Acción al cerrar sesión
                  // Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text("Cerrar sesión"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCard(currentIndex: 2),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 12),
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const SettingTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.lightGreen),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Acción al tocar la opción
      },
    );
  }
}

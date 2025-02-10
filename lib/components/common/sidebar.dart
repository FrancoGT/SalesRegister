import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salesresgistrator/components/complementaries/login_page.dart';

class Sidebar extends StatelessWidget {
  final String currentPage;

  const Sidebar({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF81C784),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            _buildNavItem(context, 'Bienvenida', Icons.home, '/welcome'),
            _buildNavItem(context, 'Productos', Icons.inventory, '/products'),
            _buildNavItem(context, 'Vendedores', Icons.people, '/sellers'),
            _buildNavItem(context, 'Ventas', Icons.attach_money, '/sales'),
            _buildNavItem(context, 'Perfil', Icons.person, '/profile'),
            const Divider(color: Colors.white), // Actualizado al color blanco
            _buildLogoutItem(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(
        color: Color(0xFF81C784), // Actualizado al color del login
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Punto de Venta',
            style: TextStyle(
              color: Colors.white, // Actualizado al color blanco
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'App',
            style: TextStyle(
              color: Colors.white, // Actualizado al color blanco
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, String route) {
    final isSelected = currentPage == route;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70), // Actualizado
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70, // Actualizado
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.exit_to_app, color: Colors.white70),
      title: const Text('Cerrar sesión', style: TextStyle(color: Colors.white70)),
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
    );
  }
}
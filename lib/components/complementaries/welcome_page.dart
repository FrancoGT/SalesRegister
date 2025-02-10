import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Método para cargar el nombre del usuario desde SharedPreferences
  _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'SuperAdmin';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bienvenido")),
      drawer: const Sidebar(currentPage: '',),  // Usamos el Sidebar existente como menú lateral
      body: Center(
        child: Text(
          'Bienvenido(a) $name',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
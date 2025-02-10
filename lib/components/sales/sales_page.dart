import 'package:flutter/material.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
      ),
      drawer: const Sidebar(currentPage: '/sales'),
      body: const Center(
        child: Text('Página de Ventas'),
      ),
    );
  }
}
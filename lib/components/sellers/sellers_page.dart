import 'package:flutter/material.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';

class SellersPage extends StatelessWidget {
  const SellersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendedores'),
      ),
      drawer: const Sidebar(currentPage: '/sellers'),
      body: const Center(
        child: Text('Página de Vendedores'),
      ),
    );
  }
}
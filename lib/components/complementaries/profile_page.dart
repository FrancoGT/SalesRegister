import 'package:flutter/material.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      drawer: const Sidebar(currentPage: '/profile'),
      body: const Center(
        child: Text('Página de Perfil'),
      ),
    );
  }
}
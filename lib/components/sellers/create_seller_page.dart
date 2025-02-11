import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesresgistrator/models/seller.dart';
import 'package:salesresgistrator/providers/sellers_provider.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';

class CreateSellerPage extends StatefulWidget {
  const CreateSellerPage({super.key});

  @override
  _CreateSellerPageState createState() => _CreateSellerPageState();
}

class _CreateSellerPageState extends State<CreateSellerPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _status = 'Active';

  void _createSeller(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final seller = Seller(
        name: _nameController.text,
        status: _status,
      );

      Provider.of<SellersProvider>(context, listen: false).addSeller(seller);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vendedor creado con éxito!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Vendedor'),
      ),
      drawer: const Sidebar(currentPage: '/createSeller'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del vendedor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Activo')),
                  DropdownMenuItem(value: 'Inactive', child: Text('Inactivo')),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value ?? 'Active';
                  });
                },
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _createSeller(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF81C784),
                    ),
                    child: const Text('Guardar', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE57373),
                    ),
                    child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
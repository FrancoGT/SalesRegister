import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesresgistrator/models/seller.dart';
import 'package:salesresgistrator/providers/sellers_provider.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';

class EditSellerPage extends StatefulWidget {
  final int sellerId;

  const EditSellerPage({Key? key, required this.sellerId}) : super(key: key);

  @override
  _EditSellerPageState createState() => _EditSellerPageState();
}

class _EditSellerPageState extends State<EditSellerPage> {
  late Seller _seller;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _status = 'Active';

  @override
  void initState() {
    super.initState();
    _loadSeller();
  }

  void _loadSeller() async {
    Seller? seller = await Provider.of<SellersProvider>(context, listen: false).getSellerById(widget.sellerId);

    if (seller != null) {
      setState(() {
        _seller = seller;
        _nameController.text = _seller.name;
        _status = _seller.status;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vendedor no encontrado')),
      );
    }
  }

  void _updateSeller(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedSeller = Seller(
        id: _seller.id,
        name: _nameController.text,
        status: _status,
      );

      Provider.of<SellersProvider>(context, listen: false).updateSeller(updatedSeller);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vendedor actualizado con éxito!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Vendedor')),
      drawer: const Sidebar(currentPage: '/editSeller'),
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
                    onPressed: () => _updateSeller(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF81C784),
                    ),
                    child: const Text('Actualizar', style: TextStyle(color: Colors.white)),
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

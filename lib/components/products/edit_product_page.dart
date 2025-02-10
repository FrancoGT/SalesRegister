import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salesresgistrator/models/product.dart';
import 'package:salesresgistrator/providers/products_provider.dart';
import 'package:salesresgistrator/components/common/sidebar.dart';

class EditProductPage extends StatefulWidget {
  final int productId;

  const EditProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late Product _product;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _status = 'Active';

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() async {
    Product? product = await Provider.of<ProductsProvider>(context, listen: false).getProductById(widget.productId);

    if (product != null) {
      setState(() {
        _product = product;
        _nameController.text = _product.name;
        _priceController.text = _product.price.toString();
        _status = _product.status;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto no encontrado')),
      );
    }
  }

  void _updateProduct(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedProduct = Product(
        id: _product.id,
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        status: _status,
      );

      Provider.of<ProductsProvider>(context, listen: false).updateProduct(updatedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto actualizado con éxito!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Producto')),
      drawer: const Sidebar(currentPage: '/editProduct'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un precio';
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
                    _status = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _updateProduct(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF81C784), // Verde pastel
                    ),
                    child: const Text('Guardar Cambios', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE57373), // Rojo suave
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
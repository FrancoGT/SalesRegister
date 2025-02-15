import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Para manejar el formato de la fecha
import 'package:salesresgistrator/components/common/custom_date_picker.dart';
import 'package:salesresgistrator/models/sale.dart';
import 'package:salesresgistrator/providers/products_provider.dart';
import 'package:salesresgistrator/providers/sellers_provider.dart';
import 'package:salesresgistrator/providers/sales_provider.dart';

class EditSalePage extends StatefulWidget {
  final int saleId;

  const EditSalePage({Key? key, required this.saleId}) : super(key: key);

  @override
  _EditSalePageState createState() => _EditSalePageState();
}

class _EditSalePageState extends State<EditSalePage> {
  late Sale _sale;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  String _paymentMethod = 'Efectivo';
  int? _selectedProductId;
  int? _selectedSellerId;

  @override
  void initState() {
    super.initState();
    _loadSale();
  }

  void _loadSale() async {
    _sale = await Provider.of<SalesProvider>(context, listen: false).getSaleById(widget.saleId);
    setState(() {
      _selectedProductId = _sale.productId;
      _selectedSellerId = _sale.sellerId;
      _quantityController.text = _sale.quantity.toString();
      _paymentMethod = _sale.paymentMethod;
    });
  }

  // Función para actualizar la venta
  void _updateSale(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedSale = Sale(
        id: _sale.id,
        date: _sale.date, // Mantiene la fecha actual si no se cambia
        sellerId: _selectedSellerId!,
        productId: _selectedProductId!,
        quantity: int.parse(_quantityController.text),
        paymentMethod: _paymentMethod,
      );

      Provider.of<SalesProvider>(context, listen: false).updateSale(updatedSale);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Venta actualizada con éxito!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }
  }

  // Actualiza la fecha en el objeto Sale
  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      _sale.date = DateFormat('yyyy-MM-dd').format(selectedDate); // Actualiza la fecha formateada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Venta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seleccionar Producto:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Consumer<ProductsProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return DropdownButtonFormField<int>(
                    value: _selectedProductId,
                    items: provider.products.map((product) {
                      return DropdownMenuItem<int>(
                        value: product.id,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProductId = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Seleccionar Vendedor:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Consumer<SellersProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return DropdownButtonFormField<int>(
                    value: _selectedSellerId,
                    items: provider.sellers.map((seller) {
                      return DropdownMenuItem<int>(
                        value: seller.id,
                        child: Text(seller.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSellerId = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una cantidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: const [
                  DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                  DropdownMenuItem(value: 'Yape', child: Text('Yape')),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value ?? 'Efectivo';
                  });
                },
                decoration: const InputDecoration(labelText: 'Método de Pago'),
              ),
              const SizedBox(height: 20),
              // Mostrar la fecha de la venta existente, si es que ya está cargada
              const SizedBox(height: 20),
              CustomDatePicker(
                initialDate: DateTime.parse(_sale.date), // Pasar la fecha inicial de la venta
                onDateSelected: _onDateSelected, // Se pasa el callback para actualizar la fecha
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _updateSale(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF81C784),
                    ),
                    child: const Text('Guardar cambios', style: TextStyle(color: Colors.white)),
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Para manejar el formato de la fecha
import 'package:salesresgistrator/components/common/custom_date_picker.dart';
import 'package:salesresgistrator/models/sale.dart';
import 'package:salesresgistrator/providers/products_provider.dart';
import 'package:salesresgistrator/providers/sellers_provider.dart';
import 'package:salesresgistrator/providers/sales_provider.dart';

class CreateSalePage extends StatefulWidget {
  final Sale? sale; // Si estamos editando, la venta se pasa como parámetro

  const CreateSalePage({super.key, this.sale});

  @override
  _CreateSalePageState createState() => _CreateSalePageState();
}

class _CreateSalePageState extends State<CreateSalePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  String _paymentMethod = 'Efectivo'; // Método de pago por defecto
  int? _selectedProductId;
  int? _selectedSellerId;
  DateTime _selectedDate = DateTime.now(); // Fecha predeterminada (actual)

  @override
  void initState() {
    super.initState();

    // Si estamos editando, asignamos la fecha de la venta
    if (widget.sale != null) {
      _selectedDate = DateTime.parse(widget.sale!.date);
      _selectedProductId = widget.sale!.productId;
      _selectedSellerId = widget.sale!.sellerId;
      _quantityController.text = widget.sale!.quantity.toString();
      _paymentMethod = widget.sale!.paymentMethod;
    }
  }

  void _createSale(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final sale = Sale(
        date: DateFormat('yyyy-MM-dd').format(_selectedDate), // Formato de la fecha al crear la venta
        sellerId: _selectedSellerId!,
        productId: _selectedProductId!,
        quantity: int.parse(_quantityController.text),
        paymentMethod: _paymentMethod, // Se incluye el método de pago
      );

      if (widget.sale == null) {
        // Crear nueva venta
        Provider.of<SalesProvider>(context, listen: false).addSale(sale);
      } else {
        // Editar venta existente
        Provider.of<SalesProvider>(context, listen: false).updateSale(sale);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Venta procesada con éxito!',
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
        title: Text(widget.sale == null ? 'Crear Venta' : 'Editar Venta'),
      ),
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
                    return 'Por favor ingresa la cantidad';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomDatePicker(
                onDateSelected: (selectedDate) {
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                }, initialDate: _selectedDate,
              ),
              const SizedBox(height: 20),
              // Agregamos el campo para seleccionar el método de pago
              const Text(
                'Seleccionar Método de Pago:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Efectivo',
                    child: Text('Efectivo'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Yape',
                    child: Text('Yape'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _createSale(context),
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
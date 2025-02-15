import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected; // Callback para obtener la fecha seleccionada
  final DateTime initialDate; // Fecha inicial

  const CustomDatePicker({
    required this.onDateSelected,
    required this.initialDate, // Se recibe la fecha inicial
    Key? key,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate; // Variable para almacenar la fecha seleccionada
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializamos la fecha con el valor pasado desde el constructor
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: "${_selectedDate.day.toString().padLeft(2, '0')}/"
          "${_selectedDate.month.toString().padLeft(2, '0')}/"
          "${_selectedDate.year}",
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900), // Fecha mínima permitida
      lastDate: DateTime(2100), // Fecha máxima permitida
      locale: const Locale('es', 'ES'), // Localización en español
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.blue,
            hintColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = "${_selectedDate.day.toString().padLeft(2, '0')}/"
            "${_selectedDate.month.toString().padLeft(2, '0')}/"
            "${_selectedDate.year}";
      });
      widget.onDateSelected(_selectedDate); // Llamar al callback con la fecha seleccionada
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Selecciona una fecha',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true, // Para que no pueda escribirse manualmente
        ),
      ),
    );
  }
}
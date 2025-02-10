import 'package:flutter/material.dart';

class SearchableDataTable extends StatefulWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final Function(int productId) onEdit;

  const SearchableDataTable({
    Key? key,
    required this.columns,
    required this.data,
    required this.onEdit,
  }) : super(key: key);

  @override
  _SearchableDataTableState createState() => _SearchableDataTableState();
}

class _SearchableDataTableState extends State<SearchableDataTable> {
  late List<Map<String, dynamic>> _filteredData;
  final TextEditingController _globalSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredData = widget.data;
  }

  @override
  void didUpdateWidget(covariant SearchableDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      setState(() {
        _filteredData = widget.data;
      });
    }
  }

  void _filterData() {
    setState(() {
      _filteredData = widget.data.where((row) {
        bool matches = true;
        String globalSearch = _globalSearchController.text.toLowerCase();
        if (globalSearch.isNotEmpty) {
          matches = row.values.any((value) =>
              value.toString().toLowerCase().contains(globalSearch));
        }
        return matches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo de búsqueda global
        TextField(
          controller: _globalSearchController,
          decoration: const InputDecoration(labelText: 'Buscar registro'),
          onChanged: (_) => _filterData(),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showCheckboxColumn: false, // Elimina la casilla de selección
            columns: widget.columns.map((column) {
              return DataColumn(
                label: Expanded(
                  child: Text(
                    column,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              );
            }).toList(),
            rows: _filteredData.map((row) {
              return DataRow(
                cells: widget.columns.map((column) {
                  if (column == 'Acciones') {
                    return DataCell(
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          int productId = row['id']; // Usamos el id del producto
                          widget.onEdit(productId); // Abrimos el editor
                        },
                      ),
                    );
                  }
                  return DataCell(Text(row[column].toString()));
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
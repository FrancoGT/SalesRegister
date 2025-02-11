import 'package:flutter/material.dart';

class SearchableDataTable extends StatefulWidget {
  final List<String> columns;
  final List<Map<String, dynamic>> data;
  final Function(int itemId)? onEdit; // Acción opcional de edición
  final Function(int itemId)? onDelete; // Acción opcional de eliminación

  const SearchableDataTable({
    Key? key,
    required this.columns,
    required this.data,
    this.onEdit,
    this.onDelete, // Acción opcional de eliminación
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Acción de edición, si se proporciona
                          if (widget.onEdit != null)
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                int itemId = row['id']; // Usamos el id del registro
                                widget.onEdit!(itemId); // Llamamos a la acción de edición
                              },
                            ),
                          // Acción de eliminación, si se proporciona
                          if (widget.onDelete != null)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                int itemId = row['id']; // Usamos el id del registro
                                widget.onDelete!(itemId); // Llamamos a la acción de eliminación
                              },
                            ),
                        ],
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
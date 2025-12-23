import 'package:flutter/material.dart';

// Student model class
class SearchItemModel{
  final String id;
  final String name;

  SearchItemModel(  {required this.id, required this.name});

  @override
  String toString() => '$name (ID: $id)';
}

class SearchableDropdownDemo extends StatefulWidget {
  const SearchableDropdownDemo({
    Key? key,
    required this.mode,
    required this.items, required this.onSelected,
  }) : super(key: key);

  final String mode;
  final List<SearchItemModel> items;
  final Function(SearchItemModel?) onSelected;


  @override
  State<SearchableDropdownDemo> createState() => _SearchableDropdownDemoState();
}

class _SearchableDropdownDemoState extends State<SearchableDropdownDemo> {
  SearchItemModel? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
          'Choose a ${widget.mode}:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SearchableDropdown(
          items: widget.items,
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onSelected(selectedValue??null);
           
          },
          hint: 'Search by name or ID',
        ),
      ],
    );
  }
}

class SearchableDropdown extends StatefulWidget {
  final List<SearchItemModel> items;
  final SearchItemModel? value;
  final ValueChanged<SearchItemModel?> onChanged;
  final String hint;

  const SearchableDropdown({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint = 'Search...',
  }) : super(key: key);

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchItemModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((student) {
          final nameLower = student.name.toLowerCase();
          final idLower = student.id.toLowerCase();
          final queryLower = query.toLowerCase();
          
          // Search in both name and ID
          return nameLower.contains(queryLower) || idLower.contains(queryLower);
        }).toList();
      }
    });
  }

  void _showSearchDialog() {
    _searchController.clear();
    _filteredItems = widget.items;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Search Faculty'),
              contentPadding: const EdgeInsets.all(16),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          _filterItems(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: _filteredItems.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('No students found'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredItems.length,
                              itemBuilder: (context, index) {
                                final student = _filteredItems[index];
                                final isSelected = widget.value?.id == student.id;
                                
                                return ListTile(
                                  title: Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'ID: ${student.id}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check, color: Colors.blue)
                                      : null,
                                  onTap: () {
                                    widget.onChanged(student);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showSearchDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: widget.value != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.value!.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'ID: ${widget.value!.id}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      widget.hint,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
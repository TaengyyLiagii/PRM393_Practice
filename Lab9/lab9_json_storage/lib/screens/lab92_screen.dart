import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';
import '../widgets/product_tile.dart';

class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  static const String _fileName = 'products_v2.json';
  
  List<Product> _products = [];
  bool _isLoading = true;
  bool _hasUnsavedChanges = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadLocalData() async {
    setState(() => _isLoading = true);
    final data = await StorageService.loadProducts(_fileName);
    setState(() {
      _products = data;
      _isLoading = false;
      _hasUnsavedChanges = false;
    });
  }

  Future<void> _saveLocalData() async {
    setState(() => _isLoading = true);
    try {
      await StorageService.saveProducts(_fileName, _products);
      setState(() {
        _isLoading = false;
        _hasUnsavedChanges = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully saved data to local storage!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving data: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _addNewProduct() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.parse(_priceController.text.trim());
      
      // Auto-generate incremental ID
      final nextId = _products.isEmpty 
          ? 1 
          : _products.map((p) => p.id).reduce((value, element) => value > element ? value : element) + 1;

      final newProduct = Product(id: nextId, name: name, price: price);

      setState(() {
        _products.add(newProduct);
        _hasUnsavedChanges = true;
      });

      _nameController.clear();
      _priceController.clear();
      Navigator.of(context).pop(); // Close bottom sheet

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added in memory. Don\'t forget to save!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddProductDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Product (Local Memory)',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.shopping_bag_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) < 0) {
                      return 'Price cannot be negative';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _addNewProduct,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add to List', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Save & Load (Local File)'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer.withAlpha(50),
                theme.colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reload from Disk',
            onPressed: () {
              if (_hasUnsavedChanges) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Discard Changes?'),
                    content: const Text('You have unsaved changes. Reloading from disk will discard them.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _loadLocalData();
                        },
                        child: const Text('Reload', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              } else {
                _loadLocalData();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Unsaved changes status banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: _hasUnsavedChanges 
                      ? Colors.orange.withAlpha(40) 
                      : Colors.green.withAlpha(40),
                  child: Row(
                    children: [
                      Icon(
                        _hasUnsavedChanges ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                        color: _hasUnsavedChanges ? Colors.orange[800] : Colors.green[800],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _hasUnsavedChanges 
                              ? 'You have unsaved changes in memory!' 
                              : 'All changes saved to storage.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _hasUnsavedChanges ? Colors.orange[900] : Colors.green[900],
                          ),
                        ),
                      ),
                      if (_hasUnsavedChanges)
                        TextButton(
                          onPressed: _saveLocalData,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange[900],
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text('SAVE NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: _products.isEmpty
                      ? Center(
                          child: Text(
                            'No products in local list.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withAlpha(127),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return ProductTile(product: _products[index]);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add_btn',
            onPressed: _showAddProductDialog,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Product'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'save_btn',
            onPressed: _hasUnsavedChanges ? _saveLocalData : null,
            backgroundColor: _hasUnsavedChanges ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
            foregroundColor: _hasUnsavedChanges ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Save to Disk'),
          ),
        ],
      ),
    );
  }
}

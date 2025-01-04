import 'package:chatting_app/provider/firebase_firestore_provider.dart';
import 'package:chatting_app/static/category.dart';
import 'package:chatting_app/static/firebase_firestore_status.dart';
import 'package:chatting_app/utils/base_color.dart';
import 'package:chatting_app/utils/ext_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add_product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  Category? _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nama',
                  label: Text('Nama'),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(
                    color: BaseColor.subtitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                items: Category.values.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(
                      category.name[0].toUpperCase() +
                          category.name.substring(1),
                    ).spd16r().textColor(),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Kategori',
                  labelStyle: TextStyle(
                    color: BaseColor.subtitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onChanged: (Category? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Harga',
                  label: Text('Harga'),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(
                    color: BaseColor.subtitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Deskripsi',
                  label: Text('Deskripsi'),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(
                    color: BaseColor.subtitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Consumer<FirebaseFirestoreProvider>(
                builder: (context, value, child) {
                  return switch (value.firestoreAddStatus) {
                    FirebaseFirestoreStatus.loading => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    _ => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _addProduct();
                            }
                          },
                          child: const Text('Simpan'),
                        ),
                      ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProduct() async {
    final provider = context.read<FirebaseFirestoreProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final name = _nameController.text;
    final price = _priceController.text;
    final description = _descriptionController.text;

    if (name.isNotEmpty &&
        price.isNotEmpty &&
        _selectedCategory?.name.toString().isNotEmpty == true &&
        description.isNotEmpty) {
      await provider.addProduct(
          name: name,
          category: _selectedCategory!.name.toString(),
          price: int.parse(price),
          description: description);
      if (!mounted) return;
      if (provider.firestoreAddStatus == FirebaseFirestoreStatus.loaded) {
        Navigator.pop(context);
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(provider.message ?? ''),
        ),
      );
    }
  }
}

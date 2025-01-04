import 'package:chatting_app/model/history.dart';
import 'package:chatting_app/provider/firebase_firestore_provider.dart';
import 'package:chatting_app/static/category.dart';
import 'package:chatting_app/static/firebase_firestore_status.dart';
import 'package:chatting_app/utils/base_color.dart';
import 'package:chatting_app/utils/ext_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailHistoryScreen extends StatefulWidget {
  static const routeName = '/detail_history';
  final History history;
  const DetailHistoryScreen({super.key, required this.history});

  @override
  State<DetailHistoryScreen> createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistoryScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.history.id.isNotEmpty) {
      _nameController.text = widget.history.name;
      _selectedCategory = Category.values.firstWhere(
        (category) => category.name == widget.history.category,
      );
      _quantityController.text = widget.history.quantity.toString();
      _totalPriceController.text = widget.history.totalPrice.toString();
      _descriptionController.text = widget.history.description;
    }
  }

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Category? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                        readOnly: true,
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
                            enabled: false,
                            child: Text(
                              category.name[0].toUpperCase() +
                                  category.name.substring(1),
                            ).spd16r().textColor(),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Kategori',
                          hintText: 'Kategori',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Jumlah',
                          label: Text('Jumlah'),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: BaseColor.subtitle,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jumlah tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _totalPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Total Harga',
                          label: Text('Total Harga'),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: TextStyle(
                            color: BaseColor.subtitle,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Total harga tidak boleh kosong';
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
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Consumer<FirebaseFirestoreProvider>(
                        builder: (context, value, child) {
                          return switch (value.firestoreDeleteStatus) {
                            FirebaseFirestoreStatus.loading => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            _ => SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _deleteTransaction,
                                  child: const Text('Hapus'),
                                ),
                              ),
                          };
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteTransaction() async {
    final provider = context.read<FirebaseFirestoreProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (widget.history.id.isNotEmpty) {
      await provider.deleteTransaction(id: widget.history.id);
      if (!mounted) return;
      if (provider.firestoreDeleteStatus == FirebaseFirestoreStatus.loaded) {
        Navigator.pop(context);
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(provider.message ?? ''),
        ),
      );
    }
  }
}

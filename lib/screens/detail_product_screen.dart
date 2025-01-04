import 'package:chatting_app/model/product.dart';
import 'package:chatting_app/provider/firebase_firestore_provider.dart';
import 'package:chatting_app/static/category.dart';
import 'package:chatting_app/static/firebase_firestore_status.dart';
import 'package:chatting_app/utils/base_color.dart';
import 'package:chatting_app/utils/ext_text.dart';
import 'package:chatting_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  static const routeName = '/detail_product';
  final Product product;
  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProductScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.product.id.isNotEmpty) {
      totalPrice = widget.product.price;
      _nameController.text = widget.product.name;
      _selectedCategory = Category.values.firstWhere(
        (category) => category.name == widget.product.category,
      );
      _priceController.text = widget.product.price.toString();
      _descriptionController.text = widget.product.description;
    }
  }

  int quantity = 1;
  late int totalPrice;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Category? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
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
                          return switch (value.firestoreUpdateStatus) {
                            FirebaseFirestoreStatus.loading => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            _ => SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _updateProduct();
                                    }
                                  },
                                  child: const Text('Ubah'),
                                ),
                              ),
                          };
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
                                  onPressed: _deleteProduct,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await _showCheckoutSheet(context,
                      product: widget.product);
                  if (result == true) {
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: const Text('Beli'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showCheckoutSheet(BuildContext context,
      {required Product product}) {
    return showModalBottomSheet<bool?>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            void incrementQuantity() {
              modalSetState(() {
                quantity++;
                totalPrice = product.price * quantity;
              });
            }

            void decrementQuantity() {
              modalSetState(() {
                if (quantity > 1) {
                  quantity--;
                  totalPrice = product.price * quantity;
                }
              });
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(product.name).spd14sm(),
                    const SizedBox(height: 4),
                    Text(totalPrice.toRupiah()).spd18sm(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jumlah').spd16r(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: decrementQuantity,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: BaseColor.danger,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Center(
                                  child: const Text('-').spd16sm().white(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(quantity.toString()).spd16sm().textColor(),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: incrementQuantity,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: BaseColor.success,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Center(
                                  child: const Text('+').spd16sm().white(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Consumer<FirebaseFirestoreProvider>(
                      builder: (context, value, child) {
                        return switch (value.firestoreAddTransactionStatus) {
                          FirebaseFirestoreStatus.loading => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          _ => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _addTransaction(product: product);
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Bayar Sekarang'),
                              ),
                            ),
                        };
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateProduct() async {
    final provider = context.read<FirebaseFirestoreProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final name = _nameController.text;
    final price = _priceController.text;
    final description = _descriptionController.text;

    if (widget.product.id.isNotEmpty &&
        name.isNotEmpty &&
        price.isNotEmpty &&
        _selectedCategory?.name.toString().isNotEmpty == true &&
        description.isNotEmpty) {
      await provider.updateProduct(
        id: widget.product.id,
        name: name,
        category: _selectedCategory!.name.toString(),
        price: int.parse(price),
        description: description,
      );
      if (!mounted) return;
      if (provider.firestoreUpdateStatus == FirebaseFirestoreStatus.loaded) {
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

  void _deleteProduct() async {
    final provider = context.read<FirebaseFirestoreProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (widget.product.id.isNotEmpty) {
      await provider.deleteProduct(id: widget.product.id);
      if (!mounted) return;
      if (provider.firestoreDeleteStatus == FirebaseFirestoreStatus.loaded) {
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

  void _addTransaction({
    required Product product,
  }) async {
    final provider = context.read<FirebaseFirestoreProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (product.id.isNotEmpty) {
      await provider.addTransaction(
        name: product.name,
        category: product.category,
        totalPrice: totalPrice,
        quantity: quantity,
        description: product.description,
      );

      if (!mounted) return;

      if (provider.firestoreAddStatus == FirebaseFirestoreStatus.loaded) {
        _nameController.clear();
        _priceController.clear();
        _descriptionController.clear();
      }

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(provider.message ?? ''),
      ));
    }
  }
}

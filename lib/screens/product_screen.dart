import 'package:chatting_app/model/product.dart';
import 'package:chatting_app/provider/firebase_firestore_provider.dart';
import 'package:chatting_app/static/screen_route.dart';
import 'package:chatting_app/utils/base_color.dart';
import 'package:chatting_app/utils/ext_text.dart';
import 'package:chatting_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    final firebaseFirestoreProvider =
        Provider.of<FirebaseFirestoreProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harfa Fashion Shop'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: StreamBuilder<List<Product>>(
          stream: firebaseFirestoreProvider.productsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data?.isEmpty == true) {
              return const Center(
                child: Text('Empty List'),
              );
            }

            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductItem(product);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddProduct,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return GestureDetector(
      onTap: () => _goToDetailProduct(product: product),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: BaseColor.border),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(product.name).spd14sm().textColor(),
                Text(product.category).spd12r().grey(),
                Text(product.price.toRupiah()).spd14m().textColor(),
                Text(product.description).spd14r().textColor(),
              ],
            ),
            ElevatedButton(
              onPressed: () => _goToDetailProduct(product: product),
              child: const Text('Beli'),
            )
          ],
        ),
      ),
    );
  }

  void _goToAddProduct() async {
    Navigator.pushNamed(
      context,
      ScreenRoute.addProduct.name,
    );
  }

  void _goToDetailProduct({required Product product}) async {
    Navigator.pushNamed(context, ScreenRoute.detailProduct.name,
        arguments: product);
  }
}

import 'package:chatting_app/model/history.dart';
import 'package:chatting_app/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirebaseFirestoreService(
    FirebaseFirestore? firebaseFirestore,
  ) : _firebaseFirestore = firebaseFirestore ??= FirebaseFirestore.instance;

  Future<void> addProduct({
    required String name,
    required String category,
    required String description,
    required int price,
    Timestamp? timestamp,
  }) async {
    try {
      final docRef = _firebaseFirestore.collection('products').doc();

      timestamp ??= Timestamp.now();
      await docRef.set({
        'id': docRef.id,
        'name': name,
        'category': category,
        'description': description,
        'price': price,
        'dateCreated': timestamp,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addTransaction({
    required String name,
    required String category,
    required String description,
    required int quantity,
    required int totalPrice,
    Timestamp? timestamp,
  }) async {
    try {
      final docRef = _firebaseFirestore.collection('transactions').doc();

      timestamp ??= Timestamp.now();
      await docRef.set({
        'id': docRef.id,
        'name': name,
        'category': category,
        'description': description,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'dateCreated': timestamp,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<Product>> getProducts() {
    try {
      return _firebaseFirestore
          .collection('products')
          .orderBy('dateCreated', descending: true)
          .snapshots()
          .map(
            (event) => event.docs.map(
              (e) {
                final data = Product.fromJson(e.data());
                return data;
              },
            ).toList(),
          );
    } catch (e) {
      throw Exception(e);
    }
  }

  Stream<List<History>> getTransactions() {
    try {
      return _firebaseFirestore
          .collection('transactions')
          .orderBy('dateCreated', descending: true)
          .snapshots()
          .map(
            (event) => event.docs.map(
              (e) {
                final data = History.fromJson(e.data());
                return data;
              },
            ).toList(),
          );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateProductById({
    required String productId,
    required Map<String, dynamic> product,
  }) async {
    try {
      return await _firebaseFirestore
          .collection('products')
          .doc(productId)
          .update(product);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteProductById({required String productId}) async {
    try {
      return await _firebaseFirestore
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteTransactionById({required String transactionId}) async {
    try {
      return await _firebaseFirestore
          .collection('transactions')
          .doc(transactionId)
          .delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}

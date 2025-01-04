import 'package:chatting_app/model/history.dart';
import 'package:chatting_app/model/product.dart';
import 'package:chatting_app/model/profile.dart';
import 'package:chatting_app/services/firebase_firestore_service.dart';
import 'package:chatting_app/static/firebase_firestore_status.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreProvider extends ChangeNotifier {
  final FirebaseFirestoreService _service;

  FirebaseFirestoreProvider(this._service);

  String? _message;
  Profile? _profile;
  FirebaseFirestoreStatus _firestoreAddStatus = FirebaseFirestoreStatus.initial;
  FirebaseFirestoreStatus _firestoreUpdateStatus =
      FirebaseFirestoreStatus.initial;
  FirebaseFirestoreStatus _firestoreDeleteStatus =
      FirebaseFirestoreStatus.initial;
  FirebaseFirestoreStatus _firestoreAddTransactionStatus =
      FirebaseFirestoreStatus.initial;

  Profile? get profile => _profile;
  String? get message => _message;
  FirebaseFirestoreStatus get firestoreAddStatus => _firestoreAddStatus;
  FirebaseFirestoreStatus get firestoreUpdateStatus => _firestoreUpdateStatus;
  FirebaseFirestoreStatus get firestoreDeleteStatus => _firestoreDeleteStatus;
  FirebaseFirestoreStatus get firestoreAddTransactionStatus =>
      _firestoreAddTransactionStatus;

  Stream<List<Product>> get productsStream => _service.getProducts();
  Stream<List<History>> get transactionsStream => _service.getTransactions();

  Future addProduct({
    required String name,
    required String category,
    required String description,
    required int price,
  }) async {
    try {
      _firestoreAddStatus = FirebaseFirestoreStatus.loading;
      notifyListeners();

      await _service.addProduct(
        name: name,
        category: category,
        price: price,
        description: description,
      );

      _firestoreAddStatus = FirebaseFirestoreStatus.loaded;
      _message = 'Berhasil menambahkan produk';
    } catch (e) {
      _message = e.toString();
      _firestoreAddStatus = FirebaseFirestoreStatus.error;
    }
    notifyListeners();
  }

  Future addTransaction({
    required String name,
    required String category,
    required String description,
    required int quantity,
    required int totalPrice,
  }) async {
    try {
      _firestoreAddTransactionStatus = FirebaseFirestoreStatus.loading;
      notifyListeners();

      await _service.addTransaction(
        name: name,
        category: category,
        quantity: quantity,
        totalPrice: totalPrice,
        description: description,
      );

      _firestoreAddTransactionStatus = FirebaseFirestoreStatus.loaded;
      _message = 'Berhasil menambahkan transaksi';
    } catch (e) {
      _message = e.toString();
      _firestoreAddTransactionStatus = FirebaseFirestoreStatus.error;
    }
    notifyListeners();
  }

  Future updateProduct({
    required String id,
    required String name,
    required String category,
    required String description,
    required int price,
  }) async {
    try {
      _firestoreUpdateStatus = FirebaseFirestoreStatus.loading;
      notifyListeners();

      await _service.updateProductById(
        productId: id,
        product: {
          'name': name,
          'category': category,
          'price': price,
          'description': description,
        },
      );

      _firestoreUpdateStatus = FirebaseFirestoreStatus.loaded;
      _message = 'Berhasil mengubah produk';
    } catch (e) {
      _message = e.toString();
      _firestoreUpdateStatus = FirebaseFirestoreStatus.error;
    }
    notifyListeners();
  }

  Future deleteProduct({
    required String id,
  }) async {
    try {
      _firestoreDeleteStatus = FirebaseFirestoreStatus.loading;
      notifyListeners();

      await _service.deleteProductById(productId: id);

      _firestoreDeleteStatus = FirebaseFirestoreStatus.loaded;
      _message = 'Berhasil menghapus produk';
    } catch (e) {
      _message = e.toString();
      _firestoreDeleteStatus = FirebaseFirestoreStatus.error;
    }
    notifyListeners();
  }

  Future deleteTransaction({
    required String id,
  }) async {
    try {
      _firestoreDeleteStatus = FirebaseFirestoreStatus.loading;
      notifyListeners();

      await _service.deleteTransactionById(transactionId: id);

      _firestoreDeleteStatus = FirebaseFirestoreStatus.loaded;
      _message = 'Berhasil menghapus transaksi';
    } catch (e) {
      _message = e.toString();
      _firestoreDeleteStatus = FirebaseFirestoreStatus.error;
    }
    notifyListeners();
  }
}

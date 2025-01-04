import 'package:chatting_app/model/history.dart';
import 'package:chatting_app/provider/firebase_firestore_provider.dart';
import 'package:chatting_app/static/screen_route.dart';
import 'package:chatting_app/utils/base_color.dart';
import 'package:chatting_app/utils/ext_text.dart';
import 'package:chatting_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final firebaseFirestoreProvider = context.read<FirebaseFirestoreProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: StreamBuilder<List<History>>(
          stream: firebaseFirestoreProvider.transactionsStream,
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

            final transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildHistoryItem(transaction);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryItem(History history) {
    return GestureDetector(
      onTap: () => _goToDetailProduct(history: history),
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
                Text(history.name).spd14sm().textColor(),
                Text("Jumlah: ${history.quantity}").spd14m().grey(),
                const SizedBox(height: 4),
                Text("Total: ${history.totalPrice.toRupiah()}")
                    .spd16m()
                    .textColor(),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: BaseColor.success,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: const Text('Dibayar').spd16m().white(),
            )
          ],
        ),
      ),
    );
  }


  void _goToDetailProduct({required History history}) async {
    Navigator.pushNamed(context, ScreenRoute.detailTransaction.name,
        arguments: history);
  }
}

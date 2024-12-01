import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan mata uang

class OwnerBalanceReportScreen extends StatelessWidget {
  // Data order sebagai contoh
  final List<Order> orders = [
    Order(
        id: '1',
        amount: 100000.0,
        date: DateTime.now().subtract(const Duration(days: 1))),
    Order(
        id: '2',
        amount: 200000.0,
        date: DateTime.now().subtract(const Duration(days: 2))),
    Order(
        id: '3',
        amount: 150000.0,
        date: DateTime.now().subtract(const Duration(days: 3))),
  ];

  OwnerBalanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menghitung total saldo
    double totalBalance = orders.fold(0, (sum, order) => sum + order.amount);

    // Format untuk tanggal dan mata uang
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan Owner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Saldo: ${currencyFormatter.format(totalBalance)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Rincian Transaksi:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          order.id,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text('ID Pesanan: ${order.id}'),
                      subtitle:
                          Text('Tanggal: ${dateFormatter.format(order.date)}'),
                      trailing: Text(
                        currencyFormatter.format(order.amount),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model untuk Order
class Order {
  final String id;
  final double amount;
  final DateTime date;

  Order({required this.id, required this.amount, required this.date});
}

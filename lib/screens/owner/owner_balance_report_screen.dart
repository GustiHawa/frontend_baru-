import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan mata uang
import 'package:http/http.dart' as http;
import 'dart:convert';

class OwnerBalanceReportScreen extends StatefulWidget {
  const OwnerBalanceReportScreen({super.key});

  @override
  _OwnerBalanceReportScreenState createState() =>
      _OwnerBalanceReportScreenState();
}

class _OwnerBalanceReportScreenState extends State<OwnerBalanceReportScreen> {
  List<Order> orders = [];
  bool isLoading = true;
  double totalBalance = 0.0;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost/rumahnugas_db/api/reports.php'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Order> fetchedOrders = (data['records'] as List)
          .map((item) => Order.fromJson(item))
          .toList();

      setState(() {
        orders = fetchedOrders;
        totalBalance = orders.fold(0, (sum, order) => sum + order.amount);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load orders');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
    setState(() {
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan Owner'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Saldo: ${currencyFormatter.format(totalBalance)}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Rincian Transaksi:',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
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
                            subtitle: Text(
                                'Tanggal: ${dateFormatter.format(order.date)}'),
                            trailing: Text(
                              currencyFormatter.format(order.amount),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
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
  final String userId;
  final String placeId;
  final double amount;
  final DateTime date;

  Order({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.amount,
    required this.date,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      placeId: json['place_id'].toString(),
      amount: double.parse(json['total_report'].toString()),
      date: DateTime.parse(json['report_date']),
    );
  }
}

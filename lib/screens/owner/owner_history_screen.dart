import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OwnerHistoryScreen extends StatefulWidget {
  final int placeId;

  const OwnerHistoryScreen({super.key, required this.placeId});

  @override
  _OwnerHistoryScreenState createState() => _OwnerHistoryScreenState();
}

class _OwnerHistoryScreenState extends State<OwnerHistoryScreen> {
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/bookings.php?place_id=${widget.placeId}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['records'];
      setState(() {
        bookings = data.map((booking) {
          return {
            'userName': booking['user_name'],
            'date': booking['booking_date'],
            'numberOfPeople': booking['number_of_people'].toString(),
            'price': booking['total_price'].toString(),
            'status': booking['status'],
            'paymentProof': booking['payment_proof'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Nama Customer: ${booking['userName']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: ${booking['date']}'),
                        Text('Jumlah Orang: ${booking['numberOfPeople']}'),
                        Text('Harga: Rp ${booking['price']}'),
                        Text('Status: ${booking['status']}'),
                        Text('Bukti Pembayaran: ${booking['paymentProof']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
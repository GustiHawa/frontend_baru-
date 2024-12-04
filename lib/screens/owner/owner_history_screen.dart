import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Mengimpor package intl
import 'dart:convert';
import 'package:http/http.dart' as http;

class OwnerHistoryScreen extends StatefulWidget {
  const OwnerHistoryScreen({super.key, required int placeId});

  @override
  _OwnerHistoryScreenState createState() => _OwnerHistoryScreenState();
}

// Kelas Pesanan untuk mendefinisikan pesanan
class Pesanan {
  final String name;
  final DateTime booking_date;
  final int number_of_people;
  final double total_price;

  Pesanan({
    required this.name,
    required this.booking_date,
    required this.number_of_people,
    required this.total_price,
  });

  // Konversi dari JSON
  factory Pesanan.fromJson(Map<String, dynamic> json) {
    try {
      final String name = json['nama_customer']?.toString() ?? 'Unknown';
      final DateTime bookingDate = DateTime.tryParse(json['tanggal']?.toString() ?? '') ?? DateTime.now();
      final int numberOfPeople = int.tryParse(json['jumlah_kursi']?.toString() ?? '0') ?? 0;
      final double totalPrice = double.tryParse(json['harga']?.toString() ?? '0.0') ?? 0.0;

      return Pesanan(
        name: name,
        booking_date: bookingDate,
        number_of_people: numberOfPeople,
        total_price: totalPrice,
      );
    } catch (e) {
      print('Error parsing Pesanan: $e');
      rethrow; // Rethrow error to be caught in the catch block
    }
  }
}

class _OwnerHistoryScreenState extends State<OwnerHistoryScreen> {
  List<Pesanan> listPesanan = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

Future<void> _fetchHistory() async {
  try {
    final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/history.php'));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}'); // Debugging response body
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        listPesanan = data.map((item) => Pesanan.fromJson(item)).toList();
      });
    } else {
      print('Server responded with status code: ${response.statusCode}');
      throw Exception('Failed to load history');
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd MMMM yyyy'); // Format tanggal: 18 November 2024

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: listPesanan.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listPesanan.length,
              itemBuilder: (context, index) {
                final pesanan = listPesanan[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Customer: ${pesanan.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text('Tanggal: ${dateFormat.format(pesanan.booking_date)}'),
                        Text('Jumlah Kursi: ${pesanan.number_of_people}'),
                        Text('Harga: Rp. ${pesanan.total_price.toStringAsFixed(2)}'),
                        const Divider(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OwnerHistoryScreen(placeId: 0,),
  ));
}

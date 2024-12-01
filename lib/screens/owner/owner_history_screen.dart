import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Mengimpor package intl

class OwnerHistoryScreen extends StatefulWidget {
  const OwnerHistoryScreen({super.key});

  @override
  _OwnerHistoryScreenState createState() => _OwnerHistoryScreenState();
}

// Kelas Pesanan untuk mendefinisikan pesanan
class Pesanan {
  final String namaCustomer;
  final DateTime tanggal;
  final int jumlahKursi;
  final double harga;

  Pesanan({
    required this.namaCustomer,
    required this.tanggal,
    required this.jumlahKursi,
    required this.harga,
  });
}

class _OwnerHistoryScreenState extends State<OwnerHistoryScreen> {
  // Daftar pesanan
  final listPesanan = [
    Pesanan(
      namaCustomer: 'Nama Customer 1',
      tanggal: DateTime.parse('2024-11-18'),
      jumlahKursi: 1,
      harga: 50000,
    ),
    Pesanan(
      namaCustomer: 'Nama Customer 2',
      tanggal: DateTime.parse('2024-11-18'),
      jumlahKursi: 2,
      harga: 30000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Format tanggal yang lebih rapi
    var dateFormat = DateFormat('dd MMMM yyyy'); // Format: 18 November 2024

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: ListView.builder(
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
                    'Nama Customer: ${pesanan.namaCustomer}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text('Tanggal: ${dateFormat.format(pesanan.tanggal)}'),
                  Text('Jumlah Kursi: ${pesanan.jumlahKursi}'),
                  Text('Harga: Rp. ${pesanan.harga.toStringAsFixed(2)}'),
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
    home: OwnerHistoryScreen(), // Menjalankan layar OwnerHistoryScreen
  ));
}

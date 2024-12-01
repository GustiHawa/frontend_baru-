import 'package:flutter/material.dart';
import 'admin_detailpayment_screen.dart' as adminDetailScreen;
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  State<AdminVerificationScreen> createState() => _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  List<Pembayaran> pembayaranList = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/bookings.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['records'];
      setState(() {
        pembayaranList = data.map<Pembayaran>((booking) {
          return Pembayaran(
            nomor: booking['id'],
            namaCustomer: booking['user_id'].toString(), // Ganti dengan nama user jika tersedia
            tanggal: booking['booking_date'],
            jumlahKursi: booking['number_of_people'].toString(),
            waktu: booking['created_at'],
            buktiTransfer: booking['payment_proof'],
          );
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data booking')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Verifikasi Pembayaran'),
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: ListView.builder(
          itemCount: pembayaranList.length,
          itemBuilder: (context, index) {
            final pembayaran = pembayaranList[index];
            return _PembayaranItem(
              pembayaran: pembayaran,
              onTerima: () {
                setState(() {
                  pembayaranList.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking diterima')),
                );
              },
              onTolak: () {
                setState(() {
                  pembayaranList.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking ditolak')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PembayaranItem extends StatelessWidget {
  const _PembayaranItem({
    required this.pembayaran,
    required this.onTerima,
    required this.onTolak,
  });

  final Pembayaran pembayaran;
  final VoidCallback onTerima;
  final VoidCallback onTolak;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${pembayaran.nomor}. ${pembayaran.namaCustomer}',
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text('Tanggal: ${pembayaran.tanggal}'),
            Text('Jumlah Kursi: ${pembayaran.jumlahKursi}'),
            Text('Waktu: ${pembayaran.waktu}'),
            SizedBox(height: size.height * 0.01),
            const Text(
              'Bukti Transfer:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.01),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => adminDetailScreen.AdminDetailPaymentScreen(
                      buktiTransfer: pembayaran.buktiTransfer,
                    ),
                  ),
                );
              },
              child: const Text(
                'Lihat Bukti Pembayaran',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: onTerima,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Terima'),
                ),
                ElevatedButton(
                  onPressed: onTolak,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Tolak'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Pembayaran {
  Pembayaran({
    required this.nomor,
    required this.namaCustomer,
    required this.tanggal,
    required this.jumlahKursi,
    required this.waktu,
    required this.buktiTransfer,
  });

  final int nomor;
  final String namaCustomer;
  final String tanggal;
  final String jumlahKursi;
  final String waktu;
  final String buktiTransfer;
}
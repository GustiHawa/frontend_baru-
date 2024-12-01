import 'package:flutter/material.dart';

class AdminDetailPaymentScreen extends StatefulWidget {
  const AdminDetailPaymentScreen({super.key, required String buktiTransfer});

  @override
  _AdminDetailPaymentScreenState createState() =>
      _AdminDetailPaymentScreenState();
}

class _AdminDetailPaymentScreenState extends State<AdminDetailPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments dengan pengecekan null
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Jika arguments null, tampilkan pesan error
    if (args == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Pembayaran'),
        ),
        body: const Center(
          child: Text('Data pembayaran tidak tersedia.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Detail Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nama User',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(args['userName'] ?? 'Nama tidak tersedia'),
            const SizedBox(height: 16),
            const Text(
              'Tanggal Pembayaran',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(args['paymentDate'] ?? 'Tanggal tidak tersedia'),
            const SizedBox(height: 16),
            const Text(
              'Jumlah Pembayaran',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(args['paymentAmount'] ?? 'Rp. 0'),
            const SizedBox(height: 16),
            const Text(
              'Bukti Transfer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: args['proofImage'] != null
                    ? Image.network(
                        args['proofImage'],
                        fit: BoxFit.cover,
                      )
                    : const Text('Bukti transfer tidak tersedia'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

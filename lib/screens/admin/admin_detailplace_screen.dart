import 'package:flutter/material.dart';

class AdminDetailPlaceScreen extends StatefulWidget {
  const AdminDetailPlaceScreen({super.key});

  @override
  _AdminDetailPlaceScreenState createState() => _AdminDetailPlaceScreenState();
}

class _AdminDetailPlaceScreenState extends State<AdminDetailPlaceScreen> {
  // Simulasi data dari arguments
  String? placeName;
  String? address;
  String? facilities;
  String? capacity;
  String? price;
  String? mainPhoto;
  List<String> additionalPhotos = []; // Simpan URL foto tambahan

  @override
  Widget build(BuildContext context) {
    // Ambil data dari arguments jika ada
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    placeName = args?['placeName'] ?? 'Nama tempat tidak tersedia';
    address = args?['address'] ?? 'Alamat tidak tersedia';
    facilities = args?['facilities'] ?? 'Fasilitas tidak tersedia';
    capacity = args?['capacity'] ?? 'Kapasitas tidak tersedia';
    price = args?['price'] ?? 'Harga tidak tersedia';
    mainPhoto = args?['mainPhoto'];
    additionalPhotos = args?['additionalPhotos'] ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Detail Tempat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Nama Tempat
            const Text(
              'Nama Tempat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(placeName!),
            const SizedBox(height: 16),

            // Alamat
            const Text(
              'Alamat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(address!),
            const SizedBox(height: 16),

            // Fasilitas
            const Text(
              'Fasilitas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(facilities!),
            const SizedBox(height: 16),

            // Kapasitas
            const Text(
              'Kapasitas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(capacity!),
            const SizedBox(height: 16),

            // Harga
            const Text(
              'Harga',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(price!),
            const SizedBox(height: 16),

            // Foto Utama
            const Text(
              'Foto Utama',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: mainPhoto != null
                  ? Image.network(mainPhoto!, fit: BoxFit.cover)
                  : const Center(child: Text('Foto utama tidak tersedia')),
            ),
            const SizedBox(height: 16),

            // Lampiran Foto Tambahan
            const Text(
              'Lampiran Foto Tambahan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: additionalPhotos.isNotEmpty
                  ? additionalPhotos
                      .map((photo) =>
                          Image.network(photo, width: 100, height: 100))
                      .toList()
                  : [const Text('Tidak ada foto tambahan')],
            ),
            const SizedBox(height: 16),

            // Tombol Setuju & Tolak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logika untuk menyetujui tempat
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tempat disetujui')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Setuju'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logika untuk menolak tempat
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tempat ditolak')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
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

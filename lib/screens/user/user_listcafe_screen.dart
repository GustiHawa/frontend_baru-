import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_detailcafe_screen.dart';

class UserListCafeScreen extends StatefulWidget {
  final String kampus;

  const UserListCafeScreen({super.key, required this.kampus, required List warkopTerdekat});

  @override
  _UserListCafeScreenState createState() => _UserListCafeScreenState();
}

class _UserListCafeScreenState extends State<UserListCafeScreen> {
  List<Map<String, dynamic>> warkopTerdekat = [];

  @override
  void initState() {
    super.initState();
    _fetchCafes();
  }

  Future<void> _fetchCafes() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/places.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['records'];
        setState(() {
          warkopTerdekat = data.map((cafe) {
            return {
              'id': cafe['id'],
              'name': cafe['name'] ?? 'Nama tidak tersedia',
              'address': cafe['address'] ?? 'Alamat tidak tersedia',
              'price': cafe['price']?.toString() ?? '0', // Konversi int ke String dan berikan nilai default
              'photo': cafe['photo'] ?? '',
            };
          }).toList();
        });
      } else {
        print('Failed to load cafes: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load cafes');
      }
    } catch (e) {
      print('Error: $e'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Cafe di ${widget.kampus}'),
        centerTitle: true,
      ),
      body: warkopTerdekat.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: warkopTerdekat.length,
              itemBuilder: (context, index) {
                final cafe = warkopTerdekat[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailCafeScreen(
                          cafeId: cafe['id'],
                          name: cafe['name'],
                          location: cafe['address'],
                          price: cafe['price'],
                          details: cafe['facilities'] ?? 'Fasilitas tidak tersedia',
                          imageUrl: cafe['photo'] ?? '', cafeName: '',
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: cafe['photo'] != null && cafe['photo'].isNotEmpty
                                ? Image.network(
                                    cafe['photo'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(child: Text('Gambar tidak tersedia'));
                                    },
                                  )
                                : const Center(child: Text('Gambar tidak tersedia')),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cafe['name'] ?? 'Nama tidak tersedia',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Harga: Rp ${cafe['price'] ?? '0'}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Alamat: ${cafe['address'] ?? 'Alamat tidak tersedia'}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
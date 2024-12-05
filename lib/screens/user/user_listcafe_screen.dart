import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_detailcafe_screen.dart';

class UserListCafeScreen extends StatefulWidget {
  final String campus;
  final int campusId;

  const UserListCafeScreen({super.key, required this.campus, required this.campusId});

  @override
  _UserListCafeScreenState createState() => _UserListCafeScreenState();
}

class _UserListCafeScreenState extends State<UserListCafeScreen> {
  List<Map<String, dynamic>> warkopTerdekat = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCafes();
  }

  Future<void> _fetchCafes() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost/rumah-nugas-backend-fix/api/places.php?campus_id=${widget.campusId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['records'] != null && data['records'] is List) {
          setState(() {
            warkopTerdekat = List<Map<String, dynamic>>.from(data['records']);
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Data kosong atau tidak valid.';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data: ${response.statusCode}';
          _isLoading = false;
        });
        print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Cafe di ${widget.campus}'),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : warkopTerdekat.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada cafe tersedia untuk kampus ini.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
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
                                  cafeName: cafe['name'] ?? 'Nama tidak tersedia',
                                  name: cafe['name'] ?? 'Nama tidak tersedia',
                                  location: cafe['address'] ?? 'Alamat tidak tersedia',
                                  price: (cafe['price'] ?? '0').toString(),
                                  details: cafe['facilities'] ?? 'Tidak ada fasilitas',
                                  imageUrl: cafe['photo'] ?? '',
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
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
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image.network(
                                              cafe['photo'],
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Center(
                                                  child: Text('Gambar tidak tersedia'),
                                                );
                                              },
                                            ),
                                          )
                                        : const Center(
                                            child: Text('Gambar tidak tersedia'),
                                          ),
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
                                            fontSize: 16,
                                          ),
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

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/userHome');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () {
              Navigator.pushNamed(context, '/userHistory');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}

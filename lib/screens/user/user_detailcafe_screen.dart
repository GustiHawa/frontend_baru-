import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_booking_screen.dart';

class UserDetailCafeScreen extends StatefulWidget {
  final int cafeId;
  final String name;
  final String location;
  final String price;
  final String details;
  final String imageUrl;

  const UserDetailCafeScreen({
    super.key,
    required this.cafeId,
    required this.name,
    required this.location,
    required this.price,
    required this.details,
    required this.imageUrl, required String cafeName,
  });

  @override
  _UserDetailCafeScreenState createState() => _UserDetailCafeScreenState();
}

class _UserDetailCafeScreenState extends State<UserDetailCafeScreen> {
  late Future<Map<String, dynamic>> _cafeDetail;

  @override
  void initState() {
    super.initState();
    _cafeDetail = _fetchCafeDetail(widget.cafeId);
  }

  Future<Map<String, dynamic>> _fetchCafeDetail(int cafeId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/place_detail.php?id=$cafeId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load cafe details: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load cafe details');
      }
    } catch (e) {
      print('Error: $e'); // Log the error
      throw Exception('Failed to load cafe details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Cafe'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _cafeDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak tersedia'));
          } else {
            return LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 600;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWideScreen ? 80 : 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gambar Cafe
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: widget.imageUrl.isNotEmpty
                              ? Image.network(
                                  widget.imageUrl,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(child: Text('Gambar tidak tersedia'));
                                  },
                                )
                              : const Center(child: Text('Gambar tidak tersedia')),
                        ),
                        const SizedBox(height: 20),
                        // Nama Cafe
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Lokasi Cafe
                        Text(
                          widget.location,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Harga Cafe
                        Text(
                          'Harga: Rp ${widget.price}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Detail Cafe
                        Text(
                          widget.details,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        // Tombol Booking
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserBookingScreen(
                                  cafeName: widget.name,
                                  placeId: widget.cafeId, // Ensure a valid int value is passed
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            minimumSize: const Size(200, 50), // Ukuran minimal tombol
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Booking Tempat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
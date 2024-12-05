import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserHistoryScreen extends StatefulWidget {
  const UserHistoryScreen({super.key});

  @override
  _UserHistoryScreenState createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null || userId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID tidak valid')),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http.get(Uri.parse(
          'http://localhost/rumah-nugas-backend-fix/api/bookings.php?user_id=$userId'));

      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Log the response body for debugging
        print('Response body: $responseBody');

        try {
          final Map<String, dynamic> decodedJson = jsonDecode(responseBody);

          if (decodedJson['success'] == true) {
            final List<dynamic> data = decodedJson['records'];
            setState(() {
              bookings = data.map((booking) {
                return {
                  'id': booking['id'],
                  'placeName': booking['place_name'] ?? 'Unknown Place',
                  'date': booking['booking_date'] ?? 'Unknown Date',
                  'address': booking['address'] ?? 'Unknown Address',
                  'numberOfPeople': booking['number_of_people']?.toString() ?? '0',
                  'price': booking['total_price']?.toString() ?? '0',
                  'status': booking['status'] ?? 'Unknown Status',
                  'photo': booking['photo'] ?? '',
                };
              }).toList();
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal memuat data booking')),
            );
          }
        } on FormatException catch (e) {
          // Handle JSON decoding error
          print('Error decoding JSON: $e');
          print('Original Response: $responseBody');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memuat data booking')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan pada server: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data booking')),
      );
      print('Error fetching bookings: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(child: Text('Tidak ada riwayat booking'))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Booking ID: ${booking['id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tempat: ${booking['placeName']}'),
                            Text('Tanggal: ${booking['date']}'),
                            Text('Alamat: ${booking['address']}'),
                            Text('Jumlah Orang: ${booking['numberOfPeople']}'),
                            Text('Harga: Rp ${booking['price']}'),
                            Text('Status: ${booking['status']}'),
                            if (booking['photo'].isNotEmpty)
                              Image.network(booking['photo']),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
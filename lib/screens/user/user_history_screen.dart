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

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null || userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID tidak valid')),
      );
      return;
    }

    final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/bookings.php?user_id=$userId'));

    String responseBody = response.body;

    // Attempt to remove HTML tags (this is a very basic example and may not handle all cases)
    String cleanedResponseBody = responseBody.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ''); // Remove tags and &nbsp;

    try {
      Map<String, dynamic> decodedJson = jsonDecode(cleanedResponseBody);
      final List<dynamic> data = decodedJson['records'];
      setState(() {
        bookings = data.map((booking) {
          return {
            'id': booking['id'],
            'placeName': booking['place_name'] ?? 'Unknown Place',
            'date': booking['booking_date'] ?? 'Unknown Date',
            'address': booking['address'] ?? 'Unknown Address',
            'numberOfPeople': booking['number_of_people'].toString(),
            'price': booking['total_price'].toString(),
            'status': booking['status'] ?? 'Unknown Status',
            'photo': booking['photo'] ?? '',
          };
        }).toList();
      });
    } on FormatException catch (e) {
      // Handle the error gracefully, perhaps display an error message to the user.
      print('Error decoding JSON: $e');
      print('Original Response: $responseBody'); // Helpful for debugging
      print('Cleaned Response: $cleanedResponseBody');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil data booking')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
        centerTitle: true,
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
                    leading: booking['photo'].isNotEmpty
                        ? Image.network(booking['photo'])
                        : null,
                    title: Text(booking['placeName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: ${booking['date']}'),
                        Text('Alamat: ${booking['address']}'),
                        Text('Jumlah Orang: ${booking['numberOfPeople']}'),
                        Text('Harga: Rp ${booking['price']}'),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          color: _getStatusColor(booking['status']),
                          child: Text('Status: ${booking['status']}'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
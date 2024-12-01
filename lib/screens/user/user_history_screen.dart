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
    final userId = prefs.getInt('user_id') ?? 0;

    final response = await http.get(Uri.parse('http://localhost/rumahnugas_db/endpoints/bookings.php?user_id=$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['records'];
      setState(() {
        bookings = data.map((booking) {
          return {
            'imageUrl': 'https://via.placeholder.com/150', // Ganti dengan URL gambar yang sesuai
            'placeName': booking['place_name'],
            'date': booking['booking_date'],
            'address': booking['address'],
            'numberOfPeople': booking['number_of_people'].toString(),
            'price': booking['total_price'].toString(),
            'status': booking['status'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load bookings');
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
                    leading: Image.network(booking['imageUrl']),
                    title: Text(booking['placeName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: ${booking['date']}'),
                        Text('Alamat: ${booking['address']}'),
                        Text('Jumlah Orang: ${booking['numberOfPeople']}'),
                        Text('Harga: Rp ${booking['price']}'),
                        Text('Status: ${booking['status']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
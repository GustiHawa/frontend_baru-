import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  State<AdminVerificationScreen> createState() => _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/bookings.php'));

      if (response.statusCode == 200) {
        String responseBody = response.body;

        // Extract the JSON part from the response
        final jsonStartIndex = responseBody.indexOf('{');
        final jsonEndIndex = responseBody.lastIndexOf('}') + 1;

        if (jsonStartIndex == -1 || jsonEndIndex == -1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengambil data booking')),
          );
          return;
        }

        final jsonString = responseBody.substring(jsonStartIndex, jsonEndIndex);

        try {
          Map<String, dynamic> decodedJson = jsonDecode(jsonString);
          final List<dynamic> data = decodedJson['records'];
          setState(() {
            bookings = data.map((booking) {
              return {
                'id': booking['id'],
                'userId': booking['user_id'],
                'date': booking['booking_date'],
                'numberOfPeople': booking['number_of_people'].toString(),
                'price': booking['total_price'].toString(),
                'status': booking['status'] ?? '', // Pastikan tipe data sesuai
                'paymentProof': booking['payment_proof'] ?? '', // Pastikan tipe data sesuai
              };
            }).toList();
          });
        } on FormatException catch (e) {
          // Handle the error gracefully, perhaps display an error message to the user.
          print('Error decoding JSON: $e');
          print('Original Response: $responseBody'); // Helpful for debugging
          print('Extracted JSON: $jsonString');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengambil data booking')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan pada server')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data booking')),
      );
      print('Error fetching bookings: $e');
    }
  }

  Future<void> _updateBookingStatus(int bookingId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/rumah-nugas-backend-fix/api/update_booking_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': bookingId, 'status': status}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking $status')),
        );
        _fetchBookings(); // Refresh bookings after update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui status booking')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui status booking')),
      );
      print('Error updating booking status: $e');
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
        title: const Text('Verifikasi Pembayaran'),
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
                    title: Text('Booking ID: ${booking['id']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User ID: ${booking['userId']}'),
                        Text('Tanggal: ${booking['date']}'),
                        Text('Jumlah Orang: ${booking['numberOfPeople']}'),
                        Text('Harga: Rp ${booking['price']}'),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          color: _getStatusColor(booking['status']),
                          child: Text('Status: ${booking['status']}'),
                        ),
                        booking['paymentProof'].startsWith('http')
                            ? Image.network(booking['paymentProof'])
                            : TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Image.memory(base64Decode(booking['paymentProof'])),
                                      );
                                    },
                                  );
                                },
                                child: const Text('Lihat Bukti Pembayaran'),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _updateBookingStatus(booking['id'], 'approved'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Approve'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _updateBookingStatus(booking['id'], 'rejected'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Reject'),
                            ),
                          ],
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
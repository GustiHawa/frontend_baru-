import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserBookingScreen extends StatefulWidget {
  final String cafeName;
  final int placeId;
  final int price;

  const UserBookingScreen({
    super.key,
    required this.cafeName,
    required this.placeId,
    required this.price,
  });

  @override
  State<UserBookingScreen> createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  int _numberOfPeople = 1;
  Uint8List? _buktiTransfer;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Memilih tanggal booking
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  // Mengambil bukti transfer (gambar)
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();

        // Validasi ukuran gambar
        if (bytes.lengthInBytes > 5 * 1024 * 1024) { // 5MB limit
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ukuran gambar terlalu besar! Maksimal 5MB')),
          );
          return;
        }

        setState(() {
          _buktiTransfer = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat memilih gambar')),
      );
    }
  }

  // Menyubmit booking data
  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      if (_buktiTransfer == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap unggah bukti transfer'),
          ),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null || userId == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID tidak valid')),
        );
        return;
      }

      final bookingData = {
        'user_id': userId,
        'place_id': widget.placeId,
        'booking_date': _dateController.text,
        'number_of_people': _numberOfPeople,
        'status_id': 1, // Assuming 1 is for 'Pending'
        'total_price': _numberOfPeople * widget.price, // Ensure this is an int
        'payment_proof': base64Encode(_buktiTransfer!),
      };

      // Log data yang akan dikirim
      print('Data sent: $bookingData');

      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse('http://localhost/rumah-nugas-backend-fix/api/bookings.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bookingData),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking berhasil disimpan'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan booking: ${response.body}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cafeName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nama'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan nama';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(labelText: 'Tanggal Booking'),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap pilih tanggal';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jumlah Orang'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (_numberOfPeople > 1) {
                                  setState(() {
                                    _numberOfPeople--;
                                  });
                                }
                              },
                            ),
                            Text('$_numberOfPeople'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _numberOfPeople++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Unggah Bukti Transfer'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pilih Gambar'),
                    ),
                    if (_buktiTransfer != null)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Image.memory(
                            _buktiTransfer!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitBooking,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Booking Sekarang'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
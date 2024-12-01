import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserBookingScreen extends StatefulWidget {
  final String cafeName;
  final int placeId;

  const UserBookingScreen({super.key, required this.cafeName, required this.placeId});

  @override
  State<UserBookingScreen> createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  int _numberOfPeople = 1;
  int pricePerPerson = 0; // Harga per orang akan diambil dari backend
  Uint8List? _buktiTransfer;

  @override
  void initState() {
    super.initState();
    _fetchPlaceDetails();
  }

  Future<void> _fetchPlaceDetails() async {
    final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/place_detail.php?id=${widget.placeId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        pricePerPerson = data['price'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil detail tempat')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes(); // Membaca file sebagai byte array
      setState(() {
        _buktiTransfer = bytes;
      });
    }
  }

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
      final userId = prefs.getInt('user_id') ?? 0;

      final response = await http.post(
        Uri.parse('http://localhost/rumah-nugas-backend-fix/api/bookings.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'place_id': widget.placeId,
          'booking_date': _dateController.text,
          'number_of_people': _numberOfPeople,
          'status_id': 1, // Assuming 1 is for 'Pending'
          'total_price': _numberOfPeople * pricePerPerson,
          'payment_proof': base64Encode(_buktiTransfer!),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking berhasil disimpan'),
          ),
        );
        // Kirim notifikasi ke admin
        _sendNotificationToAdmin();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan booking'),
          ),
        );
      }
    }
  }

  Future<void> _sendNotificationToAdmin() async {
    // Implementasikan logika untuk mengirim notifikasi ke admin
    // Misalnya, simpan ke tabel notifikasi atau kirim email
  }

  @override
  Widget build(BuildContext context) {
    // Hitung total harga berdasarkan jumlah orang
    int totalPrice = _numberOfPeople * pricePerPerson;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silahkan masukkan nama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Booking',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silahkan pilih tanggal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Jumlah Orang'),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_numberOfPeople > 1) {
                            setState(() {
                              _numberOfPeople--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$_numberOfPeople'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _numberOfPeople++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Menampilkan total harga
              Text(
                'Total Harga: Rp ${totalPrice.toString()}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Unggah Bukti Transfer:'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 10),
              if (_buktiTransfer != null)
                Column(
                  children: [
                    const Text(
                      'Bukti Transfer Terpilih:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
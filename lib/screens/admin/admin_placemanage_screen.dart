import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPlaceManageScreen extends StatefulWidget {
  const AdminPlaceManageScreen({super.key});

  @override
  State<AdminPlaceManageScreen> createState() => _AdminPlaceManageScreenState();
}

class _AdminPlaceManageScreenState extends State<AdminPlaceManageScreen> {
  List<Map<String, dynamic>> places = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApprovedPlaces();
  }

  Future<void> _loadApprovedPlaces() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/rumah-nugas-backend-fix/api/get_approved_places.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data received: $data'); // Tambahkan log ini untuk memeriksa data yang diterima
        setState(() {
          places = List<Map<String, dynamic>>.from(data['records']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menghapus tempat berdasarkan ID
  void _deletePlace(String id) {
    setState(() {
      places.removeWhere((place) => place["id"] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Manajemen Tempat'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Tempat',
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: size.width * 0.04,
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Lokasi')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: places.map((place) {
                          return DataRow(
                            cells: [
                              DataCell(Text(place["id"] ?? 'Unknown')),
                              DataCell(Text(place["name"] ?? 'Unknown')),
                              DataCell(Text(place["location"] ?? 'Unknown')),
                              DataCell(Text(place["status"] ?? 'Unknown')),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    _deletePlace(place["id"]);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
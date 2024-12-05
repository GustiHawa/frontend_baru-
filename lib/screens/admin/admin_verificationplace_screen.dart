import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rumah_nugas/screens/admin/admin_placemanage_screen.dart';

class AdminVerificationPlaceScreen extends StatefulWidget {
  const AdminVerificationPlaceScreen({super.key});

  @override
  State<AdminVerificationPlaceScreen> createState() =>
      _AdminVerificationPlaceScreenState();
}

class _AdminVerificationPlaceScreenState
    extends State<AdminVerificationPlaceScreen> {
  List<Map<String, dynamic>> places = [];
  bool isLoading = true;

  final List<String> _campusList = [
    'ITS', 'UNAIR A', 'UNAIR B', 'UNAIR C', 'UNESA', 'UBAYA', 'UINSA', 'UPN Veteran Jatim', 'Universitas Ciputra', 'Universitas Terbuka', 'Universitas Dr. Soetomo', 'Universitas Wijaya Putra', 'Universitas Muhammadiyah Surabaya', 'Universitas 17 Agustus 1945 (UNTAG)', 'Universitas Wijaya Kusuma Surabaya'
  ];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/rumah-nugas-backend-fix/api/get_places.php'));
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

  Future<void> _updatePlaceStatus(String id, String status) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost/rumah-nugas-backend-fix/api/update_place_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'status': status}),
      );
      if (response.statusCode == 200) {
        setState(() {
          places = places.where((place) => place["id"] != id).toList();
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  void _approvePlace(String id) {
    _updatePlaceStatus(id, "Approved");
    // Navigate to AdminPlaceManageScreen after approval
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminPlaceManageScreen()),
    );
  }

  void _rejectPlace(String id) {
    _updatePlaceStatus(id, "Rejected");
  }

  String _getCampusName(int campusId) {
    if (campusId > 0 && campusId <= _campusList.length) {
      return _campusList[campusId - 1];
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Tempat'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            // Tabel dengan responsivitas
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 16.0,
                                columns: [
                                  DataColumn(label: Text('Nama Tempat')),
                                  DataColumn(label: Text('Alamat')),
                                  DataColumn(label: Text('Campus Terdekat')),
                                  DataColumn(label: Text('Nomor Rekening')),
                                  DataColumn(label: Text('Status')),
                                  DataColumn(label: Text('Aksi')),
                                ],
                                rows: places.map((place) {
                                  return DataRow(
                                    cells: [
                                      DataCell(SizedBox(
                                          width: constraints.maxWidth / 5,
                                          child: Text(place["name"] ?? 'Unknown'))),
                                      DataCell(SizedBox(
                                          width: constraints.maxWidth / 5,
                                          child: Text(place["address"] ?? 'Unknown'))),
                                      DataCell(SizedBox(
                                          width: constraints.maxWidth / 5,
                                          child: Text(_getCampusName(place["campus_id"] is int ? place["campus_id"] : int.tryParse(place["campus_id"]) ?? 0)))),
                                      DataCell(SizedBox(
                                          width: constraints.maxWidth / 5,
                                          child: Text(place["account_number"] ?? 'Unknown'))),
                                      DataCell(SizedBox(
                                          width: constraints.maxWidth / 5,
                                          child: Text(place["status"] ?? 'Unknown'))),
                                      DataCell(SizedBox(
                                        width: constraints.maxWidth / 5,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.check,
                                                  color: Colors.green),
                                              onPressed: () {
                                                _approvePlace(place["id"].toString());
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.red),
                                              onPressed: () {
                                                _rejectPlace(place["id"].toString());
                                              },
                                            ),
                                          ],
                                        ),
                                      )),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
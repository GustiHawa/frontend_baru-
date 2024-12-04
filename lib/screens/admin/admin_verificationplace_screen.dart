import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminVerificationPlaceScreen extends StatefulWidget {
  const AdminVerificationPlaceScreen({super.key});

  @override
  State<AdminVerificationPlaceScreen> createState() => _AdminVerificationPlaceScreenState();
}

class _AdminVerificationPlaceScreenState extends State<AdminVerificationPlaceScreen> {
  List<Map<String, dynamic>> places = [];

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final response = await http.get(Uri.parse('http://localhost/rumah-nugas-backend-fix/api/get_places.php'));
    if (response.statusCode == 200) {
      setState(() {
        places = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Handle error
    }
  }

  Future<void> _updatePlaceStatus(String id, String status) async {
    final response = await http.post(
      Uri.parse('http://localhost/rumah-nugas-backend-fix/api/update_place_status.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id': id, 'status': status}),
    );
    if (response.statusCode == 200) {
      setState(() {
        places = places.map((place) {
          if (place["id"] == id) {
            place["status"] = status;
          }
          return place;
        }).toList();
      });
    } else {
      // Handle error
    }
  }

  void _approvePlace(String id) {
    _updatePlaceStatus(id, "Approved");
  }

  void _rejectPlace(String id) {
    _updatePlaceStatus(id, "Rejected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Tempat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16.0,
            columns: const [
              DataColumn(label: Text('Nama Tempat')),
              DataColumn(label: Text('Alamat')),
              DataColumn(label: Text('campus Terdekat')),
              DataColumn(label: Text('Nomor Rekening')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: places.map((place) {
              return DataRow(
                cells: [
                  DataCell(Text(place["name"])),
                  DataCell(Text(place["address"])),
                  DataCell(Text(place["campus"])),
                  DataCell(Text(place["account_number"])),
                  DataCell(Text(place["status"])),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            _approvePlace(place["id"]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            _rejectPlace(place["id"]);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
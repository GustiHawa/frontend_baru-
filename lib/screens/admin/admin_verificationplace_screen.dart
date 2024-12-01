import 'package:flutter/material.dart';

class AdminVerificationPlaceScreen extends StatefulWidget {
  const AdminVerificationPlaceScreen({super.key});

  @override
  State<AdminVerificationPlaceScreen> createState() => _AdminVerificationPlaceScreenState();
}

class _AdminVerificationPlaceScreenState extends State<AdminVerificationPlaceScreen> {
  // Contoh data kafe yang diinputkan oleh owner
  List<Map<String, dynamic>> places = [
    {
      "id": "1",
      "name": "Warkop A",
      "location": "Jl. Anggur, UPN",
      "status": "Pending",
      "kampus": "UPN",
      "nomorRekening": "1234567890",
    },
    {
      "id": "2",
      "name": "Cafe B",
      "location": "Jl. Pukis, ITS",
      "status": "Pending",
      "kampus": "ITS",
      "nomorRekening": "0987654321",
    },
  ];

  void _approvePlace(String id) {
    setState(() {
      places = places.map((place) {
        if (place["id"] == id) {
          place["status"] = "Approved";
        }
        return place;
      }).toList();
    });
  }

  void _rejectPlace(String id) {
    setState(() {
      places = places.map((place) {
        if (place["id"] == id) {
          place["status"] = "Rejected";
        }
        return place;
      }).toList();
    });
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
              DataColumn(label: Text('Kampus Terdekat')),
              DataColumn(label: Text('Nomor Rekening')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: places.map((place) {
              return DataRow(
                cells: [
                  DataCell(Text(place["name"])),
                  DataCell(Text(place["location"])),
                  DataCell(Text(place["kampus"])),
                  DataCell(Text(place["nomorRekening"])),
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
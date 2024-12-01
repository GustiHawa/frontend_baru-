import 'package:flutter/material.dart';

class AdminPlaceManageScreen extends StatefulWidget {
  const AdminPlaceManageScreen({super.key});

  @override
  State<AdminPlaceManageScreen> createState() => _AdminPlaceManageScreenState();
}

class _AdminPlaceManageScreenState extends State<AdminPlaceManageScreen> {
  // Data tempat disimpan dalam list
  List<Map<String, String>> places = [
    {
      "id": "1",
      "name": "Warkop A",
      "location": "Jl. Anggur, UPN",
      "status": "Aktif"
    },
    {
      "id": "2",
      "name": "Cafe B",
      "location": "Jl. Pukis, ITS",
      "status": "Aktif"
    },
  ];

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
      body: SingleChildScrollView(
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
                    DataColumn(label: Text('Hapus')),
                  ],
                  rows: places.map((place) {
                    return DataRow(
                      cells: [
                        DataCell(Text(place["id"]!)),
                        DataCell(Text(place["name"]!)),
                        DataCell(Text(place["location"]!)),
                        DataCell(Text(place["status"]!)),
                        DataCell(
                          IconButton(
                            onPressed: () {
                              _deletePlace(place["id"]!);
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

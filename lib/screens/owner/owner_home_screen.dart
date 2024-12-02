import 'package:flutter/material.dart';
import 'package:rumah_nugas/screens/welcome_screen.dart';

import 'owner_manage_store_screen.dart'; // Pastikan file ini sudah ada
import 'owner_history_screen.dart'; // Pastikan file ini sudah ada
import 'owner_balance_report_screen.dart'; // Pastikan file ini sudah ada
import 'package:shared_preferences/shared_preferences.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int placeId = 0;

  @override
  void initState() {
    super.initState();
    _loadPlaceId();
  }

  Future<void> _loadPlaceId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      placeId = prefs.getInt('place_id') ?? 0;
    });
  }

  // Fungsi untuk logout
  void _logout() {
    // Navigasi langsung ke halaman choice login setelah logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }

  // Fungsi navigasi untuk mengurangi pengulangan
  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Daftar menu yang akan ditampilkan
    final menuItems = [
      _MenuItem(Icons.grid_view, 'Kelola', const OwnerManageStoreScreen()), // Diperbarui
      _MenuItem(Icons.receipt_long, 'Riwayat Pesanan', OwnerHistoryScreen(placeId: placeId)), // Diperbarui
      _MenuItem(Icons.money, 'Laporan Keuangan', OwnerBalanceReportScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nama Tempat'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  onTap: () => _navigateToScreen(item.screen),
                );
              },
            ),
          ),
          // Tombol logout di bagian bawah
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Warna tombol
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Kelas untuk menyimpan informasi menu
class _MenuItem {
  final IconData icon;
  final String title;
  final Widget screen;

  _MenuItem(this.icon, this.title, this.screen);
}
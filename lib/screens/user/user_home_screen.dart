import 'package:flutter/material.dart';
import 'package:rumah_nugas/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_listcafe_screen.dart';
import 'user_history_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RUMAH NUGAS"),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Booking'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserHistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Text(
              "RUMAH NUGAS",
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            // Subtitle
            const Text(
              "Cari tempat nugas dan nongkrong di Surabaya",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            // Buttons for universities
            Expanded(
              child: ListView(
                children: [
                  _buildLocationButton(context, "ITS"),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UNAIR"),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UPN"),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UNESA"),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UBAYA"),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UINSA"),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "Universitas Terbuka"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat tombol lokasi
  Widget _buildLocationButton(BuildContext context, String location) {
    return SizedBox(
      width: double.infinity,
      height: 50.0, // Tinggi seragam untuk semua tombol
      child: ElevatedButton(
        onPressed: () {
          // Navigasi ke halaman daftar cafe dengan parameter kampus
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserListCafeScreen(kampus: location, warkopTerdekat: [],),
            ),
          );
        },
        child: Text(location, style: const TextStyle(fontSize: 16.0)),
      ),
    );
  }
}
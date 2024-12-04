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
        automaticallyImplyLeading: false, // This removes the back button
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
                  _buildLocationButton(context, "ITS", 1),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UNAIR A", 2),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UNAIR B", 3),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UNAIR C", 4),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UNESA", 5),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UBAYA", 6),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UINSA", 7),
                   const SizedBox(height: 16.0),
                  _buildLocationButton(context, "UPN Veteran Jatim", 8),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "Universitas Ciputra", 9),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "Universitas Terbuka", 10),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "Universitas Dr. Soetomo", 11),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "Universitas Wijaya Putra", 12),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "Universitas Muhammadiyah Surabaya", 13),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "Universitas 17 Agustus 1945 (UNTAG)", 14),
                  const SizedBox(height: 16.0),
                  _buildLocationButton(context, "Universitas Wijaya Kusuma Surabaya", 15),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat tombol lokasi
  Widget _buildLocationButton(BuildContext context, String location, int campusId) {
    return SizedBox(
      width: double.infinity,
      height: 50.0, // Tinggi seragam untuk semua tombol
      child: ElevatedButton(
        onPressed: () {
          // Navigasi ke halaman daftar cafe dengan parameter campus
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserListCafeScreen(campus: location, campusId: campusId),
            ),
          );
        },
        child: Text(location, style: const TextStyle(fontSize: 16.0)),
      ),
    );
  }
}
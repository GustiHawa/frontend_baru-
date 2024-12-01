import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rumah Nugas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Rumah Nugas!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Log In untuk Lanjut',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke LoginScreen
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Klik Disini!',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
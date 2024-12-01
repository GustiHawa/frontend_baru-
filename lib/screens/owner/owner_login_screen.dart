import 'package:flutter/material.dart';
import 'owner_home_screen.dart'; // Pastikan file ini sudah diimport

class OwnerLoginScreen extends StatefulWidget {
  const OwnerLoginScreen({super.key});

  @override
  _OwnerLoginScreenState createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Login logic here, ganti dengan logika autentikasi yang sesungguhnya
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');

      // Setelah login berhasil, arahkan ke halaman OwnerHomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OwnerHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              // Tambahkan link untuk registrasi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigasi ke halaman registrasi
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

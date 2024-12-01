import 'package:flutter/material.dart';
import 'admin_verification_screen.dart';
import 'admin_commissionreport_screen.dart';
import 'admin_placemanage_screen.dart';
import 'admin_verificationplace_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.05,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Bagian Verifikasi dan Komisi
                  Row(
                    children: [
                      Expanded(
                        child: _DashboardCard(
                          title: 'Verifikasi Pembayaran',
                          value: '2',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminVerificationScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: _DashboardCard(
                          title: 'Komisi',
                          value: 'Rp. 30.000',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminCommissionreportScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Bagian Manajemen Tempat dan Persetujuan Tempat
                  Row(
                    children: [
                      Expanded(
                        child: _DashboardCard(
                          title: 'Manajemen Tempat',
                          value: '8',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminPlaceManageScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: _DashboardCard(
                          title: 'Persetujuan Tempat',
                          value: '5',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AdminVerificationPlaceScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
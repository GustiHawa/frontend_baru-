import 'package:flutter/material.dart';

// Import screens
import 'screens/welcome_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';

import 'screens/user/user_home_screen.dart';
import 'screens/user/user_history_screen.dart';
import 'screens/user/user_listcafe_screen.dart' as listcafe;
import 'screens/user/user_detailcafe_screen.dart' as detailcafe;
import 'screens/user/user_booking_screen.dart' as booking;

import 'screens/owner/owner_home_screen.dart';
import 'screens/owner/owner_manage_store_screen.dart';
import 'screens/owner/owner_history_screen.dart';
import 'screens/owner/owner_balance_report_screen.dart';

import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_verification_screen.dart';
import 'screens/admin/admin_placemanage_screen.dart';
import 'screens/admin/admin_commissionreport_screen.dart';
import 'screens/admin/admin_verificationplace_screen.dart';
import 'screens/admin/admin_detailpayment_screen.dart';
import 'screens/admin/admin_detailplace_screen.dart';

// Define app-wide constants for consistency
const primaryColor = Colors.blue;
const backgroundColor = Colors.white;
const appBarTitleStyle = TextStyle(color: Colors.white, fontSize: 20);
const bodyTextStyle = TextStyle(color: Colors.black, fontSize: 16);
const subtitleTextStyle = TextStyle(color: Colors.grey, fontSize: 14);
const headingTextStyle = TextStyle(color: Colors.black, fontSize: 24);
const buttonColor = Colors.blue;
const buttonTextStyle = TextStyle(color: Colors.white, fontSize: 16);

void main() => runApp(const RumahNugasApp());

class RumahNugasApp extends StatelessWidget {
  const RumahNugasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rumah Nugas',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          centerTitle: true,
          titleTextStyle: appBarTitleStyle,
        ),
        textTheme: const TextTheme(
          bodyLarge: bodyTextStyle,
          bodyMedium: subtitleTextStyle,
          titleLarge: headingTextStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: buttonTextStyle,
          ),
        ),
      ),
      initialRoute: '/',
      routes: _defineRoutes(),
    );
  }

  /// Define application routes
  Map<String, WidgetBuilder> _defineRoutes() {
    return {
      // Common routes
      '/': (context) => const WelcomeScreen(),
      '/register': (context) => const RegisterScreen(),
      '/login': (context) => const LoginScreen(),




      // User routes
      '/userHome': (context) => const UserHomeScreen(),
      '/userHistory': (context) => const UserHistoryScreen(),
      '/userListcafe': (context) => listcafe.UserListCafeScreen(
            campus: ModalRoute.of(context)?.settings.arguments as String? ?? '',
            campusId: (ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>?)?['campusId'],
          ),
      '/userDetailcafe': (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
        return detailcafe.UserDetailCafeScreen(
          name: args['name'] ?? 'Cafe Example',
          location: args['location'] ?? 'Unknown Location',
          price: args['price'] ?? '0',
          details: args['details'] ?? 'No details available.',
          imageUrl: args['imageUrl'] ?? '',
          cafeName: args['cafeName'] ?? '',
          cafeId: args['cafeId'] ?? 0,
        );
      },
      '/userBooking': (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
        return booking.UserBookingScreen(
          cafeName: args['cafeName'] ?? 'Unknown Cafe',
          placeId: args['placeId'] ?? 0,
          price: args['price'] ?? '0',
        );
      },

      // Owner routes
      '/ownerHome': (context) => const OwnerHomeScreen(),
      '/ownerManageStore': (context) => const OwnerManageStoreScreen(),
      '/ownerHistory': (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
        return OwnerHistoryScreen(
          placeId: args['placeId'] ?? 0,
        );
      },
      '/ownerBalanceReport': (context) => const OwnerBalanceReportScreen(),

      // Admin routes
      '/adminDashboard': (context) => const AdminDashboardScreen(),
      '/adminVerification': (context) => const AdminVerificationScreen(),
      '/adminPlaceManage': (context) => const AdminPlaceManageScreen(),
      '/adminCommissionReport': (context) => const AdminCommissionreportScreen(),
      '/adminDetailPayment': (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
        return AdminDetailPaymentScreen(
          buktiTransfer: args['buktiTransfer'] ?? '',
        );
      },
      '/adminVerificationPlace': (context) => const AdminVerificationPlaceScreen(),
      '/adminDetailPlace': (context) => const AdminDetailPlaceScreen(),
    };
  }
}




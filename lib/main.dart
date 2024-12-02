import 'package:flutter/material.dart';

// Import screens;
import 'screens/welcome_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart'; // Ensure this import is used

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

// Define the missing variables
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
          bodyLarge: bodyTextStyle, // bodyLarge menggantikan bodyText1
          bodyMedium: subtitleTextStyle, // bodyMedium menggantikan bodyText2
          titleLarge: headingTextStyle, // titleLarge menggantikan headline6
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                buttonColor, // Gunakan backgroundColor sebagai pengganti primary
            foregroundColor: Colors.white, // Gunakan foregroundColor sebagai pengganti onPrimary
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: buttonTextStyle,
          ),
        ),
      ),
      initialRoute: '/', // Set initial route to '/'
      routes: {
        // Common routes
        '/': (context) => const WelcomeScreen(), // Ensure this is the correct initial screen
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(), // Ensure LoginScreen is referenced here

        // User routes
        '/userHome': (context) => const UserHomeScreen(),
        '/userHistory': (context) => const UserHistoryScreen(),
        '/userListcafe': (context) => listcafe.UserListCafeScreen(kampus: '', warkopTerdekat: []),
        '/userDetailcafe': (context) => detailcafe.UserDetailCafeScreen(
          name: 'Cafe Example',
          location: '123 Example St',
          price: '\$\$',
          details: 'This is an example cafe.',
          imageUrl: 'photo', cafeName: '', cafeId: 0, // Ensure a valid int value is passed
        ),
        '/userBooking': (context) => booking.UserBookingScreen(cafeName: 'Cafe Example', placeId: 1), // Ensure a valid int value is passed

        // Owner routes
        '/ownerHome': (context) => const OwnerHomeScreen(),
        '/ownerManageStore': (context) => const OwnerManageStoreScreen(),
        '/ownerHistory': (context) => const OwnerHistoryScreen(placeId: 0,),
        '/ownerBalanceReport': (context) => OwnerBalanceReportScreen(),

        // Admin routes
        '/adminDashboard': (context) => const AdminDashboardScreen(),
        '/adminVerification': (context) => const AdminVerificationScreen(),
        '/adminPlaceManage': (context) => const AdminPlaceManageScreen(),
        '/adminCommissionReport': (context) => const AdminCommissionreportScreen(),
        '/adminDetailPayment': (context) => const AdminDetailPaymentScreen(buktiTransfer: ''),
        '/adminVerificationPlace': (context) => const AdminVerificationPlaceScreen(),
        '/adminDetailPlace': (context) => const AdminDetailPlaceScreen(),
      },
    );
  }
}
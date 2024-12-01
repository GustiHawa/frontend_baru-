// styles.dart
import 'package:flutter/material.dart';

// Warna utama
const Color primaryColor = Colors.blue;
const Color backgroundColor = Colors.white;
const Color buttonColor = Color.fromRGBO(68, 138, 255, 1);

// Gaya teks
const TextStyle appBarTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle headingTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle bodyTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
);

const TextStyle subtitleTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.black54,
);

const TextStyle buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

// Gaya untuk container dengan shadow
BoxDecoration containerBoxDecoration = const BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(10)),
  boxShadow: [
    BoxShadow(
      color: Colors.grey,
      blurRadius: 2,
      spreadRadius: 1,
      offset: Offset(0, 2),
    ),
  ],
);

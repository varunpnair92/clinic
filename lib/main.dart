import 'package:clinic/doctor.dart';
import 'package:clinic/login.dart';
import 'package:clinic/reception_home.dart';
import 'package:clinic/register.dart';
import 'package:clinic/report.dart';
import 'package:clinic/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Clinic Patient Management',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () =>  LoginPage()),
        GetPage(name: '/reception', page: () => const ReceptionistHomePage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/search', page: () => const SearchPage()),
        GetPage(name: '/doctor', page: () => const DoctorPage()),
        GetPage(name: '/reports', page: () => const ReportsPage()),
      ],
    );
  }
}

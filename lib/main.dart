import 'package:clinic/admin.dart';
import 'package:clinic/doctor.dart';
import 'package:clinic/login_check_middleware.dart';
import 'package:clinic/login.dart';
import 'package:clinic/reception_home.dart';
import 'package:clinic/register.dart';
import 'package:clinic/report.dart';
import 'package:clinic/search.dart';
import 'package:clinic/search_edit.dart';
import 'package:clinic/usermanagment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        GetPage(name: '/reception', page: () => const ReceptionistHomePage(),middlewares: [RoleMiddleware(allowedRoles: ['doctor', 'receptionist'])],),
        GetPage(name: '/register', page: () => const RegisterPage(),middlewares: [RoleMiddleware(allowedRoles: ['doctor', 'receptionist'])],),
        GetPage(name: '/search_old', page: () => const SearchPage(),middlewares: [RoleMiddleware(allowedRoles: ['doctor', 'receptionist'])],),
        GetPage(name: '/doctor', page: () => const DoctorPage(),middlewares: [RoleMiddleware(allowedRoles: ['doctor'])],),
        GetPage(name: '/reports', page: () => const ReportsPage()),
        GetPage(name: '/search', page: () => const PatientSearchAndEditPage(),middlewares: [RoleMiddleware(allowedRoles: ['doctor', 'receptionist'])],),
         GetPage(name: '/user', page: () =>  UserManagementPage(),middlewares: [RoleMiddleware(allowedRoles: ['doctor', 'receptionist'])],),
         GetPage(name: '/admin', page: () =>  AdminPanelPage(),middlewares: [RoleMiddleware(allowedRoles: ['admin'])],),
      ],
    );
  }
}

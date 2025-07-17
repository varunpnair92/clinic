import 'package:clinic/usermanagment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminPanelPage extends StatelessWidget {
  const AdminPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => UserManagementPage());
          },
          child: const Text('Go to User Management'),
        ),
      ),
    );
  }
}

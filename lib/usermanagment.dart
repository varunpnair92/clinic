import 'package:clinic/center_page.dart';
import 'package:clinic/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserManagementPage extends StatelessWidget {
  final userController = Get.put(ApiController());

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final changeUserController = TextEditingController();
  final newPasswordController = TextEditingController();

  UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredPage(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Add New User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username')),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password')),
            Obx(() => DropdownButton<String>(
                  value: userController.selectedRole.isEmpty
                      ? null
                      : userController.selectedRole.value,
                  hint: const Text('Select Role'),
                  items: userController.roleOptions.map((role) {
                    return DropdownMenuItem<String>(
                      value: role['key'],
                      child: Text(role['label'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    userController.selectedRole.value = value ?? '';
                  },
                )),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                userController.addUser(
                  usernameController.text,
                  passwordController.text,
                  userController.selectedRole.value, // ✅ Use selected role
                );
              },
              child: const Text('Add User'),
            ),
            const Divider(height: 30, thickness: 2),
            const Text('Change Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
                controller: changeUserController,
                decoration:
                    const InputDecoration(labelText: 'Username')),
            TextField(
                controller: newPasswordController,
                decoration:
                    const InputDecoration(labelText: 'New Password')),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                userController.changePassword(
                  changeUserController.text,
                  newPasswordController.text,
                );
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

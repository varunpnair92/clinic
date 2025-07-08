import 'package:clinic/center_page.dart';
import 'package:clinic/controller.dart';
import 'package:clinic/doctor.dart';
import 'package:clinic/reception_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final api = Get.put(ApiController());

    return CenteredPage(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Clinic Login",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: "Username"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: "Password"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final success = await api.loginUser(
                usernameController.text,
                passwordController.text,
              );

              if (success) {
                if (api.loggedInUser['role'] == 'doctor') {
                  Get.off(() => const DoctorPage());
                } else {
                  Get.off(() => const ReceptionistHomePage());
                }
              } else {
                Get.snackbar("Error", "Login failed");
              }
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}

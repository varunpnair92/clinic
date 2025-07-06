import 'package:clinic/controller.dart';
import 'package:clinic/doctor.dart';
import 'package:clinic/reception_home.dart';
import 'package:clinic/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final api = Get.put(ApiController());

    return Scaffold(
      appBar: AppBar(title: Text("Login"),
      leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => Get.back(),
  ),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
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
                    Get.off(() => const ReceptionistHomePage()); // You need to make this
                  }
                } else {
                  Get.snackbar("Error", "Login failed");
                }
              },
              child: Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}




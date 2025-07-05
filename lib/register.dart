import 'package:clinic/center_page.dart';
import 'package:clinic/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final apiController = Get.put(ApiController());

    return CenteredPage(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Register New Patient', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            TextFormField(controller: ageCtrl, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
            TextFormField(controller: genderCtrl, decoration: const InputDecoration(labelText: 'Gender')),
            TextFormField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
            TextFormField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Address')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final data = {
                  'name': nameCtrl.text,
                  'age': int.tryParse(ageCtrl.text) ?? 0,
                  'gender': genderCtrl.text,
                   'phone': phoneCtrl.text,
                  'address': {
                   
                    'address': addressCtrl.text
                  }
                };
                await apiController.registerPatient(data);
                Get.back();
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}

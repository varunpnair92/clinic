import 'package:clinic/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const PatientApp());
}

class PatientApp extends StatelessWidget {
  const PatientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Patient Register',
      debugShowCheckedModeBanner: false,
      home: const PatientRegisterPage(),
    );
  }
}

class PatientRegisterPage extends StatelessWidget {
  const PatientRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatientController());

    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth < 600 ? screenWidth * 0.9 : 400.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Registration'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: formWidth,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (val) => controller.name.value = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter name' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => controller.age.value = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter age' : null,
                ),
                Obx(() => DropdownButtonFormField(
                      value: controller.gender.value,
                      items: ['Male', 'Female', 'Other']
                          .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g),
                              ))
                          .toList(),
                      onChanged: (val) => controller.gender.value = val!,
                      decoration: const InputDecoration(labelText: 'Gender'),
                    )),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => controller.contact.value = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter contact' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.register,
                  child: const Text('Register'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

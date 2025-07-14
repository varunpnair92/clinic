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
  final genderCtrl = TextEditingController();  // Kept for structure, but unused
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  DateTime? selectedDob;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final apiController = Get.put(ApiController());

    return CenteredPage(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(  // Added to handle overflow in small screens
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Register New Patient',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name')),

              TextFormField(
                  controller: ageCtrl,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number),

              // 📅 Date of Birth Picker
              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDob = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration:
                      const InputDecoration(labelText: 'Date of Birth'),
                  child: Text(
                    selectedDob == null
                        ? 'Select Date'
                        : "${selectedDob!.day}/${selectedDob!.month}/${selectedDob!.year}",
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ⬇️ Gender Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                value: selectedGender,
                items: ['Male', 'Female'].map((gender) {
                  return DropdownMenuItem(
                      value: gender, child: Text(gender));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),

              TextFormField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: 'Phone')),

              TextFormField(
                  controller: addressCtrl,
                  decoration: const InputDecoration(labelText: 'Address')),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  final data = {
                    'name': nameCtrl.text,
                    'age': int.tryParse(ageCtrl.text) ?? 0,
                    'dob': selectedDob?.toIso8601String().substring(0, 10),
                    'gender': selectedGender,
                    'phone': phoneCtrl.text,
                    'address': {
                      'address': addressCtrl.text
                    }
                  };

                  await apiController.registerPatient(data);
                  Get.back();
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

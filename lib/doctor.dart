import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'controller.dart';

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    final api = Get.put(ApiController());
    final queryController = TextEditingController();
    final remarksController = TextEditingController();
    final prescriptionController = TextEditingController();
    final xrayBytes = Rx<Uint8List?>(null);
    final xrayName = RxString('');
    final manualDateEnabled = false.obs;
    final selectedVisitDate = Rx<DateTime?>(null);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Doctor Panel")),
            ListTile(
              title: const Text("Reports"),
              onTap: () => Get.toNamed('/reports'),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Left: Search Panel
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('Search', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                    focusNode: focusNode,
                    autofocus: true,
                    controller: queryController,
                    decoration: const InputDecoration(labelText: 'Name / Phone / OP'),
                    onSubmitted: (val) => api.searchPatient(val).then((_) => focusNode.requestFocus()),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(() => ListView.builder(
                          itemCount: api.searchResults.length,
                          itemBuilder: (_, index) {
                            final p = api.searchResults[index];
                            return ListTile(
                              title: Text(p['name'] ?? 'Unknown'),
                              subtitle: Text(p['phone'] ?? 'N/A'),
                              onTap: () => api.selectedPatient.value = p,
                            );
                          },
                        )),
                  ),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/reception'),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),

          // Middle: Patient Details + Add Visit
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final patient = api.selectedPatient.value;
                if (patient == null) {
                  return const Center(child: Text("No Patient Selected"));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Patient Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("OP: ${patient['op_number'] ?? 'N/A'}"),
                      Text("Name: ${patient['name'] ?? 'N/A'}"),
                      Text("Age: ${patient['age'] ?? 'N/A'}"),
                      Text("Gender: ${patient['gender'] ?? 'N/A'}"),
                      Text("Phone: ${patient['phone'] ?? 'N/A'}"),
                      Text("Address: ${patient['address']?['address'] ?? 'N/A'}"),
                      Text("Last Visit: ${patient['last_visit_days_ago'] ?? 'N/A'}"),
                      const Divider(),

                      const Text('Add Visit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: remarksController,
                        decoration: const InputDecoration(labelText: 'Remarks'),
                        maxLines: null,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: prescriptionController,
                        decoration: const InputDecoration(labelText: 'Prescription'),
                        maxLines: null,
                      ),

                      const SizedBox(height: 8),
                      Obx(() => CheckboxListTile(
                            title: const Text('Set Custom Visit Date'),
                            value: manualDateEnabled.value,
                            onChanged: (value) => manualDateEnabled.value = value!,
                          )),

                      Obx(() => manualDateEnabled.value
                          ? InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  selectedVisitDate.value = picked;
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(selectedVisitDate.value == null
                                      ? 'Pick Visit Date'
                                      : "${selectedVisitDate.value!.toLocal()}".split(' ')[0]),
                                ),
                              ),
                            )
                          : const SizedBox()),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await FilePicker.platform.pickFiles(type: FileType.image);
                              if (result != null && result.files.single.bytes != null) {
                                xrayBytes.value = result.files.single.bytes;
                                xrayName.value = result.files.single.name;
                              }
                            },
                            icon: const Icon(Icons.upload),
                            label: const Text("Pick X-Ray"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await api.addVisitWithImage(
                                patientId: patient['id'],
                                reason: remarksController.text,
                                prescription: prescriptionController.text,
                                xrayBytes: xrayBytes.value,
                                fileName: xrayName.value,
                                visitDate: manualDateEnabled.value ? selectedVisitDate.value : null,
                              );

                              await api.searchPatient(patient['name']);
                              api.selectedPatient.value =
                                  api.searchResults.firstWhere((p) => p['id'] == patient['id']);

                              remarksController.clear();
                              prescriptionController.clear();
                              xrayBytes.value = null;
                              xrayName.value = '';
                              manualDateEnabled.value = false;
                              selectedVisitDate.value = null;
                            },
                            child: const Text("Add Visit"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // Right: Visit History
          Expanded(
            flex: 3,
            child: Obx(() {
              final patient = api.selectedPatient.value;
              if (patient == null) return const SizedBox();
              final visits = patient['visits'] ?? [];
              return ListView.builder(
                itemCount: visits.length,
                itemBuilder: (_, index) {
                  final visit = visits[index];
                  final date = visit['visit_date'] ?? '';
                  final reason = visit['reason'] ?? '';
                  final xrayUrl = visit['xray_url'];
                  return ListTile(
                    title: Text(date),
                    subtitle: Text(reason),
                    trailing: xrayUrl != null
                        ? Image.network(xrayUrl, height: 40, width: 40, fit: BoxFit.cover)
                        : null,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

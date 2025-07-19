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
          // Left: Search
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
                  const Text(
                    'Search',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    focusNode: focusNode,
                    autofocus: true,
                    controller: queryController,
                    decoration: const InputDecoration(
                      labelText: 'Name / Phone / OP',
                    ),
                    onSubmitted: (val) => api
                        .searchPatient(val)
                        .then((_) => focusNode.requestFocus()),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                        itemCount: api.searchResults.length,
                        itemBuilder: (_, index) {
                          final p = api.searchResults[index];
                          return ListTile(
                            title: Text(p['name'] ?? 'Unknown'),
                            subtitle: Text(p['phone'] ?? 'N/A'),
                            onTap: () => api.selectedPatient.value = p,
                          );
                        },
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/reception');
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),

          // Middle: Patient Info + Add Visit Block
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Patient Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text("op Number: ${patient['op_number'] ?? 'N/A'}"),
                          Text("Name: ${patient['name'] ?? 'N/A'}"),
                          Text("Age: ${patient['age'] ?? 'N/A'}"),
                          Text("Gender: ${patient['gender'] ?? 'N/A'}"),
                          Text("Phone: ${patient['phone'] ?? 'N/A'}"),
                          Text(
                            "Address: ${patient['address']?['address'] ?? 'N/A'}",
                          ),
                          Text(
                            style: TextStyle(color: Colors.green),
                            "last visit: ${patient['last_visit_days_ago'] ?? 'N/A'}",
                          ),
                          const Divider(height: 20, thickness: 2),
                          const SizedBox(height: 20),
                          const Text(
                            'Add Visit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: remarksController,
                            decoration: const InputDecoration(
                              labelText: 'Remarks',
                            ),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: prescriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Prescription',
                            ),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                          const SizedBox(height: 10),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width:180,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final result = await FilePicker.platform
                                        .pickFiles(type: FileType.image);
                                    if (result != null &&
                                        result.files.single.bytes != null) {
                                      xrayBytes.value = result.files.single.bytes;
                                      xrayName.value = result.files.single.name;
                                    }
                                  },
                                  icon: const Icon(Icons.upload),
                                  label: const Text("Pick X-Ray"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width:180,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  label: const Text('Add Visit'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  
                                  onPressed: () async {
                                    final id = patient['id'];
                                    final reason = remarksController.text;
                                    final prescription =
                                        prescriptionController.text;
                                
                                    final visitId = await api.addVisitWithImage(
                                      patientId: id,
                                      reason: reason,
                                      prescription: prescription,
                                      xrayBytes: xrayBytes.value,
                                      fileName: xrayName.value,
                                    );
                                
                                    if (visitId != null) {
                                      await api.searchPatient(patient['name']);
                                      api.selectedPatient.value = api
                                          .searchResults
                                          .firstWhere(
                                            (p) => p['id'] == patient['id'],
                                          );
                                      remarksController.clear();
                                      prescriptionController.clear();
                                      xrayBytes.value = null;
                                      xrayName.value = '';
                                    }
                                  },
                                  
                                ),
                              ),

                               const SizedBox(height: 20),
                              SizedBox(
                                width:180,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  label: const Text('Delete Patient'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirm Delete'),
                                        content: const Text(
                                          'Are you sure you want to delete this patient? This action cannot be undone.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                
                                    if (confirmed == true) {
                                      final success = await api.deletePatient(
                                        patient['id'],
                                      );
                                      if (success) {
                                        Get.snackbar(
                                          'Deleted',
                                          'Patient deleted successfully.',
                                        );
                                        api.selectedPatient.value = null;
                                        queryController.clear();
                                        await api.searchPatient(
                                          '',
                                        ); // Refresh patient list
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'Failed to delete patient.',
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),

          // Right: Visit History
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final patient = api.selectedPatient.value;
                if (patient == null) return const SizedBox();

                final visits = patient['visits'] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Visit History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: visits.length,
                        itemBuilder: (_, index) {
                          final visit = visits[index];
                          final vdate = visit['visit_date'] ?? '';
                          final reason = visit['reason'] ?? '';
                          final prescriptions = visit['prescriptions'] ?? [];
                          final xrayUrl = visit['xray_url'];
                          final prescriptionText = prescriptions
                              .map(
                                (p) =>
                                    '💊 ${p['medicine_name']} - ${p['instructions']}',
                              )
                              .join("\n");

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 60.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vdate,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(reason),
                                        if (prescriptionText.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(prescriptionText),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (xrayUrl != null &&
                                      xrayUrl.toString().trim().isNotEmpty)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => Get.dialog(
                                          Dialog(
                                            insetPadding: const EdgeInsets.all(
                                              20,
                                            ),
                                            child: InteractiveViewer(
                                              child: Image.network(
                                                xrayUrl,
                                                fit: BoxFit.contain,
                                                loadingBuilder:
                                                    (context, child, progress) {
                                                      if (progress == null) {
                                                        return child;
                                                      }

                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: Image.network(
                                            xrayUrl,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

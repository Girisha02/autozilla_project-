/// ✅ vehicle_detail_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '/camera/camera_capture_screen.dart';
import 'vehicle_details_summary_page.dart'; // <-- Added import

class VehicleDetailPage extends StatefulWidget {
  const VehicleDetailPage({super.key});

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedLanguage = 'English';

  final List<String> directions = ['Front', 'Rear', 'Left', 'Right'];
  final List<String> languages = ['English', 'Hindi', 'Telugu', 'Tamil'];

  Map<String, File?> capturedImages = {
    'Front': null,
    'Rear': null,
    'Left': null,
    'Right': null,
  };

  Future<void> _openCameraCapture(String direction) async {
    final imageFile = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCaptureScreen(direction: direction),
      ),
    );
    if (imageFile != null) {
      setState(() {
        capturedImages[direction] = imageFile;
      });
    }
  }

  void _onSaveAndNext() {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final vehicleType = _vehicleTypeController.text;
    final lang = _selectedLanguage;

    if (name.isEmpty || phone.isEmpty || vehicleType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => VehicleDetailsSummaryPage(
              customerName: name,
              phoneNumber: phone,
              vehicleType: vehicleType,
              preferredLanguage: lang,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Vehicle Survey')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  directions.map((dir) {
                    return Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () => _openCameraCapture(dir),
                        ),
                        Text(dir),
                      ],
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _vehicleTypeController,
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Preferred Language',
              ),
              items:
                  languages
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
              onChanged: (val) => setState(() => _selectedLanguage = val!),
            ),
            const SizedBox(height: 20),
            ...directions.map((dir) {
              final file = capturedImages[dir];
              return file != null
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$dir Image:'),
                      const SizedBox(height: 5),
                      Image.file(file, height: 150, fit: BoxFit.cover),
                      const SizedBox(height: 10),
                    ],
                  )
                  : const SizedBox.shrink();
            }).toList(),
            Center(
              child: ElevatedButton(
                onPressed: _onSaveAndNext,
                child: const Text('Save and Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

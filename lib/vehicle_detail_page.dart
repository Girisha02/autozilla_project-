// vehicle_detail_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/camera/camera_capture_screen.dart';

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

  String? _selectedLanguage;

  final List<String> directions = ['Front', 'Rear', 'Left', 'Right'];
  final List<String> languages = ['English', 'Telugu', 'Hindi', 'Tamil'];

  Map<String, List<File>> capturedImages = {
    'Front': [],
    'Rear': [],
    'Left': [],
    'Right': [],
  };

  Future<void> _openCameraCapture(String direction) async {
    final imageFiles = await Navigator.push<List<File>>(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCaptureScreen(direction: direction),
      ),
    );
    if (imageFiles != null && imageFiles.isNotEmpty) {
      setState(() {
        capturedImages[direction] = imageFiles;
      });
    }
  }

  void _showImagePreview(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  title: const Text('Image Preview'),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Expanded(
                  child: InteractiveViewer(
                    child: Image.file(imageFile, fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

    try {
      context.push(
        '/vehicle-details-summary',
        extra: {
          'customerName': name,
          'phoneNumber': phone,
          'vehicleType': vehicleType,
          'preferredLanguage': lang,
          'capturedImages': capturedImages,
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Navigation error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Vehicle Survey',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
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
                decoration: const InputDecoration(
                  hintText: 'Customer Name',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _vehicleTypeController,
                decoration: const InputDecoration(
                  hintText: 'Vehicle Type',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                            value: _selectedLanguage,
                            decoration: const InputDecoration(
              hintText: 'Preferred Language',
              hintStyle: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            isExpanded: true,
                            dropdownColor: Colors.black,
                            items:
                languages
                    .map(
                      (lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(
                          lang,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                            onChanged: (val) => setState(() => _selectedLanguage = val!),
                            ),
              const SizedBox(height: 20),
              ...directions.map((dir) {
                final files = capturedImages[dir] ?? [];
                return files.isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$dir Images (${files.length}):'),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _showImagePreview(context, files[index]);
                                      },
                                      child: Image.file(
                                        files[index],
                                        height: 150,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            files.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                    : const SizedBox.shrink();
              }),
              Center(
                child: ElevatedButton(
                  onPressed: _onSaveAndNext,
                  child: const Text('Save and Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

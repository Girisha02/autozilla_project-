import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DamageAssessmentPage extends StatefulWidget {
  final String jobId;
  final String car;
  final String customerName;
  final Map<String, List<File>>? capturedImages;
  final List<Map<String, String>>? existingDamages;

  const DamageAssessmentPage({
    super.key,
    required this.jobId,
    required this.car,
    required this.customerName,
    this.capturedImages,
    this.existingDamages,
  });

  @override
  State<DamageAssessmentPage> createState() => _DamageAssessmentPageState();
}

class _DamageAssessmentPageState extends State<DamageAssessmentPage> {
  final TextEditingController _damageDescriptionController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _capturedImages = [];
  final List<Map<String, String>> _allDamages = [];
  String? _selectedDamageType;

  final List<String> _damageTypes = [
    'Scratches',
    'Dents',
    'Broken lights',
    'Cracked windshield',
    'Bumper damage',
    'Paint damage',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with existing damages if any
    if (widget.existingDamages != null) {
      _allDamages.addAll(widget.existingDamages!);
    }
  }

  @override
  void dispose() {
    _damageDescriptionController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _damageDescriptionController.clear();
      _selectedDamageType = null;
      _capturedImages.clear();
    });
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _capturedImages.add(File(photo.path));
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo captured successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error capturing photo: $e')));
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        setState(() {
          _capturedImages.add(File(photo.path));
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo selected from gallery!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking photo: $e')));
      }
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

  void _recordVoice() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Voice input tapped')));
  }

  void _goToNext() {
    String description = _damageDescriptionController.text;

    if (_selectedDamageType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a damage type')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter damage description')),
      );
      return;
    }

    // Add current damage to the list
    final currentDamage = {
      'type': _selectedDamageType!,
      'description': description,
      'jobId': 'JOB-${_allDamages.length + 1}',
    };
    _allDamages.add(currentDamage);

    // Debug: Print the number of damages
    print('Total damages now: ${_allDamages.length}');
    for (int i = 0; i < _allDamages.length; i++) {
      print('Damage $i: ${_allDamages[i]}');
    }

    // Combine all captured images
    final allImages = <String, List<File>>{};
    if (widget.capturedImages != null) {
      allImages.addAll(widget.capturedImages!);
    }
    allImages['Damage'] = _capturedImages;

    // Navigate to Damage Summary Page with all damages
    context
        .push(
          '/damage-summary',
          extra: {
            'jobId': widget.jobId,
            'car': widget.car,
            'damageType': _selectedDamageType,
            'damage': description,
            'customerName': widget.customerName,
            'capturedImages': allImages,
            'allDamages': _allDamages, // Pass all damages
          },
        )
        .then((_) {
          // Don't clear the form when returning from damage summary
          // This allows us to add more damages
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Damage Assessment'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display existing damages if any
            if (_allDamages.isNotEmpty) ...[
              const Text(
                'Existing Damages:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._allDamages.asMap().entries.map((entry) {
                final index = entry.key;
                final damage = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Damage ${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                damage['type'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Job ID: ${damage['jobId']}'),
                        const SizedBox(height: 4),
                        Text('Description: ${damage['description']}'),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],

            // Damage Type Selection
            const Text(
              'Damage Type:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._damageTypes.map(
              (type) => RadioListTile<String>(
                title: Text(type),
                value: type,
                groupValue: _selectedDamageType,
                onChanged: (value) {
                  setState(() {
                    _selectedDamageType = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Damage Description
            TextField(
              controller: _damageDescriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Damage Description',
                hintText: 'Enter any visible damage details...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Voice Input
            IconButton(
              onPressed: _recordVoice,
              icon: const Icon(Icons.mic, size: 32, color: Colors.blue),
              tooltip: 'Tap to speak',
            ),
            const SizedBox(height: 20),

            // Photo Capture
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Photos'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: _capturePhoto,
                      icon: const Icon(Icons.camera_alt, size: 36),
                      tooltip: 'Capture photo',
                    ),
                    IconButton(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library, size: 36),
                      tooltip: 'Pick from gallery',
                    ),
                  ],
                ),
                if (_capturedImages.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Captured Images (${_capturedImages.length}):'),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _capturedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showImagePreview(
                                    context,
                                    _capturedImages[index],
                                  );
                                },
                                child: Image.file(
                                  _capturedImages[index],
                                  height: 120,
                                  width: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _capturedImages.removeAt(index);
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
                ],
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _goToNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'NEXT',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

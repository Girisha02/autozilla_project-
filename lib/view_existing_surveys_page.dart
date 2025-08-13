import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ViewExistingSurveysPage extends StatefulWidget {
  const ViewExistingSurveysPage({super.key});

  @override
  State<ViewExistingSurveysPage> createState() =>
      _ViewExistingSurveysPageState();
}

class _ViewExistingSurveysPageState extends State<ViewExistingSurveysPage> {
  String? enteredName;
  bool isListening = false;
  final TextEditingController _nameController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  // Mock data - in real app this would come from a database
  final Map<String, List<Map<String, String>>> _vehicleData = {
    'jane smith': [
      {
        'name': 'Tesla Model 3',
        'year': '2020',
        'id': 'ABC1234',
        'image': 'assets/tesla_model_3.png',
      },
      {
        'name': 'Mercedes-Benz GLE',
        'year': '2021',
        'id': 'XYZ5678',
        'image': 'assets/mercedes_gle.png',
      },
    ],
    'john smith': [
      {
        'name': 'BMW X5',
        'year': '2019',
        'id': 'BMW789',
        'image': 'assets/bmw_x5.png',
      },
    ],
  };

  Future<void> _startListening() async {
  try {
    if (isListening) {
      // Stop recording
      final String? filePath = await _audioRecorder.stop();
      setState(() {
        isListening = false;
      });

      if (filePath != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Recording saved: ${filePath.split('/').last}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Start recording
      final bool hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission required'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Corrected: Pass RecordConfig as the positional argument
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc, // Specify the audio encoder
          bitRate: 128000, // Bit rate (optional, adjust as needed)
          sampleRate: 44100, // Sample rate (optional, adjust as needed)
        ),
        path: filePath, // Path as a named argument
      );

      setState(() {
        isListening = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recording started... Tap again to stop'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  } catch (e) {
    setState(() {
      isListening = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recording error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  void _searchForVehicles(String name) {
    final normalizedName = name.toLowerCase();
    setState(() {
      enteredName = _vehicleData.containsKey(normalizedName) ? name : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Existing Surveys'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (enteredName == null) ...[
                    // Initial state - placeholder and tap to speak
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Vehicle Owner',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Enter owner name',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _startListening,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color:
                                        isListening ? Colors.red : Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isListening ? Icons.mic : Icons.mic_none,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'Type or speak the owner name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  if (_nameController.text.isNotEmpty) {
                                    _searchForVehicles(_nameController.text);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_nameController.text.isNotEmpty) {
                                _searchForVehicles(_nameController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32.0,
                                vertical: 12.0,
                              ),
                            ),
                            child: const Text('Search Vehicles'),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Display vehicle details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Vehicle Owner',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.mic,
                                size: 20.0,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            enteredName!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...(_vehicleData[enteredName!.toLowerCase()] ?? [])
                              .map(
                                (vehicle) => GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/vehicle-details-summary',
                                      extra: {
                                        'customerName': enteredName,
                                        'phoneNumber': '+1 (555) 123-4567',
                                        'vehicleType': vehicle['name'],
                                        'preferredLanguage': 'English',
                                        'isExistingSurvey': true,
                                        'vehicleYear': vehicle['year'],
                                        'vehicleId': vehicle['id'],
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.directions_car,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                vehicle['name']!,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                vehicle['year']!,
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                vehicle['id']!,
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }
}

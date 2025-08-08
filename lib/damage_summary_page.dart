import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class DamageSummaryPage extends StatefulWidget {
  final String jobId;
  final String car;
  final String damage;
  final String damageType;
  final String customerName;
  final Map<String, List<File>>? capturedImages;
  final List<Map<String, String>>? allDamages;

  const DamageSummaryPage({
    super.key,
    required this.jobId,
    required this.car,
    required this.damage,
    required this.damageType,
    required this.customerName,
    this.capturedImages,
    this.allDamages, // Optional parameter for existing damages
  });

  @override
  State<DamageSummaryPage> createState() => _DamageSummaryPageState();
}

class _DamageSummaryPageState extends State<DamageSummaryPage> {
  final List<Map<String, String>> _allDamages = [];

  @override
  void initState() {
    super.initState();
    // Initialize with existing damages if any
    if (widget.allDamages != null) {
      _allDamages.addAll(widget.allDamages!);
      print(
        'DamageSummaryPage: Received ${widget.allDamages!.length} existing damages',
      );
    } else {
      // Add the current damage to the list if no existing damages
      _allDamages.add({
        'type': widget.damageType,
        'description': widget.damage,
        'jobId': widget.jobId,
      });
      print('DamageSummaryPage: Added single damage');
    }
    print('DamageSummaryPage: Total damages now: ${_allDamages.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Damage'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigned Job',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Job ID: ${widget.jobId}'),
            const SizedBox(height: 8),
            Text('Car: ${widget.car}'),
            const SizedBox(height: 20),

            const Text(
              'All Damages:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
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
                              color: Colors.blue,
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
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Go back to damage assessment page to add more damage
                      // Pass the current damages list so it can be preserved
                      context.push(
                        '/damage-assessment',
                        extra: {
                          'jobId': widget.jobId,
                          'car': widget.car,
                          'customerName': widget.customerName,
                          'capturedImages': widget.capturedImages,
                          'existingDamages': _allDamages,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      'ADD DAMAGE',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/customer-interaction-log',
                        extra: {
                          'customerName': widget.customerName,
                          'capturedImages': widget.capturedImages,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

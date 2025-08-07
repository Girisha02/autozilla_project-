import 'package:flutter/material.dart';
import 'package:myapp/damage_summary_page.dart'; // Make sure this file exists

class DamageAssessmentPage extends StatefulWidget {
  final String jobId;
  final String car;

  const DamageAssessmentPage({
    super.key,
    required this.jobId,
    required this.car,
  });

  @override
  State<DamageAssessmentPage> createState() => _DamageAssessmentPageState();
}

class _DamageAssessmentPageState extends State<DamageAssessmentPage> {
  final TextEditingController _damageDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    _damageDescriptionController.dispose();
    super.dispose();
  }

  void _capturePhoto() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Camera tapped')));
  }

  void _recordVoice() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Voice input tapped')));
  }

  void _goToNext() {
    String description = _damageDescriptionController.text;

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter damage description')),
      );
      return;
    }

    // Navigate to Damage Summary Page with jobId, car, and damage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DamageSummaryPage(
              jobId: widget.jobId,
              car: widget.car,
              damage: description,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Damage Assessment'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ❌ Removed vehicle display

            // ✅ Damage Description
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

            // ✅ Voice Input
            IconButton(
              onPressed: _recordVoice,
              icon: const Icon(Icons.mic, size: 32, color: Colors.blue),
              tooltip: 'Tap to speak',
            ),
            const SizedBox(height: 20),

            // ✅ Photo Capture
            Column(
              children: [
                const Text('Photos'),
                const SizedBox(height: 8),
                IconButton(
                  onPressed: _capturePhoto,
                  icon: const Icon(Icons.camera_alt, size: 36),
                  tooltip: 'Capture photo',
                ),
              ],
            ),
            const SizedBox(height: 30),

            // ✅ Save and Next Button
            ElevatedButton(
              onPressed: _goToNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

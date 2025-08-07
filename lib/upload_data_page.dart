import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // ✅ Import GoRouter for navigation

class UploadDataPage extends StatefulWidget {
  final String category;
  final String description;
  final String severity;
  final String actionRequired;
  final String photoPath; // Path to the image file

  const UploadDataPage({
    super.key,
    required this.category,
    required this.description,
    required this.severity,
    required this.actionRequired,
    required this.photoPath,
  });

  @override
  State<UploadDataPage> createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  bool isUploading = false;
  bool hasNetworkIssue = false;
  bool isQueued = false;

  void _simulateUpload() async {
    setState(() => isUploading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (hasNetworkIssue) {
      setState(() {
        isQueued = true;
        isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Network issue! Data queued for upload."),
          backgroundColor: Colors.redAccent,
        ),
      );

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          _simulateUpload(); // Auto re-attempt upload
          setState(() {
            hasNetworkIssue = false;
            isQueued = false;
          });
        }
      });
    } else {
      if (!mounted) return;
      setState(() => isUploading = false);
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Success"),
              content: const Text("Survey completed successfully."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    context.go('/welcome'); // ✅ Navigate to welcome page
                  },
                  child: const Text("Go to Home"),
                ),
              ],
            ),
      );
    }
  }

  void _queueDataManually() {
    setState(() {
      hasNetworkIssue = true;
    });
    _simulateUpload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Data"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Review Collected Data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            _buildRow("Issue Category", widget.category),
            _buildRow("Issue Description", widget.description),
            _buildRow("Severity", widget.severity),
            _buildRow("Action Required", widget.actionRequired),
            _buildRow("Photo", ""),
            Image.asset(widget.photoPath, width: 100, height: 100),
            const SizedBox(height: 30),
            Center(
              child:
                  isUploading
                      ? const CircularProgressIndicator()
                      : Column(
                        children: [
                          ElevatedButton(
                            onPressed: _simulateUpload,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              "Confirm and Upload",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: _queueDataManually,
                            child: const Text("Queue Data if No Connection"),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text("$label:")),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

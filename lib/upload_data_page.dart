import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UploadDataPage extends StatefulWidget {
  final List<Map<String, dynamic>> allIssues;
  final Map<String, List<File>>? capturedImages;

  const UploadDataPage({
    super.key,
    required this.allIssues,
    this.capturedImages,
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Network issue! Data queued for upload."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }

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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data uploaded successfully!')),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                    context.go('/welcome'); // Navigate to welcome page
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
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildIssueCard(Map<String, dynamic> issue, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Issue ${index + 1}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(issue['severity'] ?? ''),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    issue['severity'] ?? '',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow("Category", issue['category'] ?? ''),
            _buildDetailRow("Description", issue['description'] ?? ''),
            _buildDetailRow("Actions Required", issue['actionRequired'] ?? ''),
            _buildDetailRow("Estimated Cost", (issue['cost'] ?? '').isNotEmpty ? "₹${issue['cost']}" : "Not specified"),
            _buildDetailRow("Remarks", issue['remarks'] ?? ''),
            const SizedBox(height: 16),
            if (issue['photos'] != null && issue['photos'] is List && (issue['photos'] as List).isNotEmpty) ...[
              const Text(
                "Photos",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (issue['photos'] as List).length,
                  itemBuilder: (context, index) {
                    final photo = (issue['photos'] as List)[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          _showImagePreview(context, photo);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            photo,
                            height: 120,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'major':
        return Colors.orange;
      case 'minor':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Data"),
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
            Row(
              children: [
                const Text(
                  "Review Collected Data",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "${widget.allIssues.length} Issue${widget.allIssues.length == 1 ? '' : 's'}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...widget.allIssues.asMap().entries.map((entry) {
              return _buildIssueCard(entry.value, entry.key);
            }),
            const SizedBox(height: 30),
            
            // Display all captured images
            if (widget.capturedImages != null && widget.capturedImages!.isNotEmpty) ...[
              const Text(
                "All Captured Images",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...widget.capturedImages!.entries.map((entry) {
                if (entry.value.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${entry.key} Images (${entry.value.length})",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                                                         child: GestureDetector(
                               onTap: () {
                                 _showImagePreview(context, entry.value[index]);
                               },
                               child: ClipRRect(
                                 borderRadius: BorderRadius.circular(8),
                                 child: Image.file(
                                   entry.value[index],
                                   height: 120,
                                   width: 160,
                                   fit: BoxFit.cover,
                                 ),
                               ),
                             ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
              const SizedBox(height: 20),
            ],
            Center(
              child:
                  isUploading
                      ? const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Uploading data..."),
                        ],
                      )
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "Not specified" : value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

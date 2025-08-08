import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class IssueCategorizationPage extends StatefulWidget {
  final Map<String, List<File>>? capturedImages;
  final String? vehicleRegNo;
  final String? vehicleModel;
  final String? claimNo;

  const IssueCategorizationPage({
    super.key,
    this.capturedImages,
    this.vehicleRegNo,
    this.vehicleModel,
    this.claimNo,
  });

  @override
  State<IssueCategorizationPage> createState() =>
      _IssueCategorizationPageState();
}

class _IssueCategorizationPageState extends State<IssueCategorizationPage> {
  String? _selectedIssueCategory;
  String? _selectedSeverity;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final Map<String, bool> _actions = {
    'Replace': false,
    'Repair': false,
    'Paint': false,
    'Clean': false,
  };

  final List<Map<String, dynamic>> _savedIssues = [];
  final List<File> _capturedPhotos = [];

  void _resetForm() {
    setState(() {
      _selectedIssueCategory = null;
      _selectedSeverity = null;
      _descriptionController.clear();
      _costController.clear();
      _remarksController.clear();
      _actions.forEach((key, value) => _actions[key] = false);
      _capturedPhotos.clear();
    });
  }

  Future<void> _capturePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _capturedPhotos.add(File(photo.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error capturing photo: $e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        setState(() {
          _capturedPhotos.add(File(photo.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking photo: $e')),
        );
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

  void _addIssue() {
    if (_selectedIssueCategory == null ||
        _selectedSeverity == null ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields"),
        ),
      );
      return;
    }

    final issue = <String, dynamic>{
      'category': _selectedIssueCategory,
      'description': _descriptionController.text,
      'severity': _selectedSeverity,
      'actions':
          _actions.entries.where((e) => e.value).map((e) => e.key).toList(),
      'cost': _costController.text,
      'remarks': _remarksController.text,
      'photos': List<File>.from(_capturedPhotos), // Store a copy of File objects
    };
    


    setState(() {
      _savedIssues.add(issue);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Issue Added")));

    _resetForm();
  }

  void _goToUploadPage() {
    if (_savedIssues.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add at least one issue before proceeding"),
        ),
      );
      return;
    }

    // Convert all saved issues to a format that can be passed via GoRouter
    final List<Map<String, dynamic>> convertedIssues = _savedIssues.map((issue) {
      final actionsList = issue['actions'] as List<dynamic>;
      final actionRequired = actionsList.map((e) => e.toString()).join(", ");
      
      final convertedIssue = {
        'category': issue['category']?.toString() ?? '',
        'description': issue['description']?.toString() ?? '',
        'severity': issue['severity']?.toString() ?? '',
        'actionRequired': actionRequired,
        'photos': issue['photos'] as List<dynamic>, // Pass as dynamic to avoid type issues
        'cost': issue['cost']?.toString() ?? '',
        'remarks': issue['remarks']?.toString() ?? '',
      };
      

      
      return convertedIssue;
    }).toList();

    // Combine all captured images
    final allImages = <String, List<File>>{};
    if (widget.capturedImages != null) {
      allImages.addAll(widget.capturedImages!);
    }
    allImages['Issues'] = _capturedPhotos;

    context.push('/upload-data', extra: {
      'allIssues': convertedIssues,
      'capturedImages': allImages,
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Issue Categorization'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Vehicle Reg. No. ${widget.vehicleRegNo ?? 'ABC 1234'}"),
              Text("Model: ${widget.vehicleModel ?? 'Example Car'}"),
              Text("Claim No: ${widget.claimNo ?? 'CL123456789'}"),
              const SizedBox(height: 20),
              const Text("Issue Category"),
              DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select Category"),
                value: _selectedIssueCategory,
                items:
                    ["Engine", "Body", "Electrical", "Other"].map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                onChanged:
                    (value) => setState(() => _selectedIssueCategory = value),
              ),
              const SizedBox(height: 12),
              const Text("Issue Description"),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "e.g. Front bumper cracked",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text("Severity"),
              DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select Severity"),
                value: _selectedSeverity,
                items:
                    ["Minor", "Major", "Critical"].map((sev) {
                      return DropdownMenuItem(value: sev, child: Text(sev));
                    }).toList(),
                onChanged: (value) => setState(() => _selectedSeverity = value),
              ),
              const SizedBox(height: 12),
              const Text("Action Required"),
              Wrap(
                children:
                    _actions.keys.map((action) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _actions[action],
                            onChanged:
                                (val) => setState(
                                  () => _actions[action] = val ?? false,
                                ),
                          ),
                          Text(action),
                        ],
                      );
                    }).toList(),
              ),
              const SizedBox(height: 12),
              const Text("Estimated Cost"),
              TextField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: "₹ ",
                  hintText: "Enter estimated cost",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text("Photos"),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _capturePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Gallery"),
                    ),
                  ),
                ],
              ),
              if (_capturedPhotos.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Captured Images (${_capturedPhotos.length}):'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _capturedPhotos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                                                             child: GestureDetector(
                                 onTap: () {
                                   _showImagePreview(context, _capturedPhotos[index]);
                                 },
                                 child: Image.file(
                                   _capturedPhotos[index],
                                   height: 120,
                                   width: 160,
                                   fit: BoxFit.cover,
                                 ),
                               ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _capturedPhotos.removeAt(index);
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
              const SizedBox(height: 12),
              const Text("Remarks"),
              TextField(
                controller: _remarksController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Additional notes or comments",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: _resetForm,
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: _addIssue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text("Add"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _goToUploadPage,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Proceed to Upload"),
              ),
              const SizedBox(height: 20),
              if (_savedIssues.isNotEmpty) const Divider(),
              if (_savedIssues.isNotEmpty)
                const Text(
                  "Saved Issues",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              for (var issue in _savedIssues)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category: ${issue['category']}"),
                      Text("Description: ${issue['description']}"),
                      Text("Severity: ${issue['severity']}"),
                      Text(
                        "Actions: ${(issue['actions'] as List<String>).join(", ")}",
                      ),
                      Text("Estimated Cost: ₹${issue['cost']}"),
                      Text("Remarks: ${issue['remarks']}"),
                      if (issue['photo'] != null && issue['photo'].toString().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(
                            File(issue['photo']),
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(Icons.photo, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

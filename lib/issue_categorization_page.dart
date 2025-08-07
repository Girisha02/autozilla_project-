import 'package:flutter/material.dart';
import 'upload_data_page.dart'; // Ensure this file exists with correct constructor

class IssueCategorizationPage extends StatefulWidget {
  const IssueCategorizationPage({super.key});

  @override
  State<IssueCategorizationPage> createState() =>
      _IssueCategorizationPageState();
}

class _IssueCategorizationPageState extends State<IssueCategorizationPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  String? _selectedIssueCategory;
  String? _selectedSeverity;

  final List<Map<String, dynamic>> _savedIssues = [];

  Map<String, bool> _actions = {
    'Replace': false,
    'Repair': false,
    'No Action': false,
  };

  void _resetForm() {
    setState(() {
      _selectedIssueCategory = null;
      _selectedSeverity = null;
      _descriptionController.clear();
      _costController.clear();
      _remarksController.clear();
      _actions.updateAll((key, value) => false);
    });
  }

  void _addIssue() {
    if (_selectedIssueCategory == null ||
        _selectedSeverity == null ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all mandatory fields")),
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
      'photo': 'assets/sample_photo.jpg',
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

    final lastIssue = _savedIssues.last;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => UploadDataPage(
              category: lastIssue['category'],
              description: lastIssue['description'],
              severity: lastIssue['severity'],
              actionRequired: (lastIssue['actions'] as List<String>).join(", "),
              photoPath: lastIssue['photo'],
            ),
      ),
    );
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Vehicle Reg. No. ABC 1234"),
              const Text("Model: Example Car"),
              const Text("Claim No: CL123456789"),
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
              ElevatedButton.icon(
                onPressed:
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Photo upload tapped")),
                    ),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Add Photo"),
              ),
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

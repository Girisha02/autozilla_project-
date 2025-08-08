import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class CustomerInteractionLogPage extends StatefulWidget {
  final String customerName;
  final Map<String, List<File>>? capturedImages;

  const CustomerInteractionLogPage({
    super.key,
    required this.customerName,
    this.capturedImages,
  });

  @override
  State<CustomerInteractionLogPage> createState() =>
      _CustomerInteractionLogPageState();
}

class _CustomerInteractionLogPageState
    extends State<CustomerInteractionLogPage> {
  String? _selectedRepairType;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  final TextEditingController _commentsController = TextEditingController();

  final List<String> _repairOptions = ['Replace', 'Repair', 'Paint Only'];
  final List<String> _timeSlots = [
    '09:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 06:00 PM',
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  void _saveAndConfirm() {
    if (_selectedRepairType == null ||
        _selectedDate == null ||
        _selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    // ✅ Optionally log the collected info (for now we're just navigating)
    context.push(
      '/issue-categorization',
      extra: {
        'capturedImages': widget.capturedImages,
        'vehicleRegNo': 'ABC 1234', // This should come from previous pages
        'vehicleModel': 'Example Car', // This should come from previous pages
        'claimNo': 'CL123456789', // This should come from previous pages
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Interaction Log'),
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
            const Text(
              'Customer Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(widget.customerName),
            const SizedBox(height: 20),

            const Text(
              'Preferred Repair Type:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedRepairType,
              items:
                  _repairOptions
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _selectedRepairType = value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select repair type',
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Next Availability for Pickup:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickDate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text(
                _selectedDate != null
                    ? 'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Select Date',
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedTimeSlot,
              items:
                  _timeSlots
                      .map(
                        (slot) =>
                            DropdownMenuItem(value: slot, child: Text(slot)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTimeSlot = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select time slot',
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Comments or Requests:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentsController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter any comments or special requests...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _saveAndConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Save and Confirm',
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

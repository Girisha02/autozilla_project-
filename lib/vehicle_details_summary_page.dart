import 'package:flutter/material.dart';
import 'package:myapp/damage_assesment_page.dart';

class VehicleDetailsSummaryPage extends StatefulWidget {
  final String customerName;
  final String phoneNumber;
  final String vehicleType;
  final String preferredLanguage;

  const VehicleDetailsSummaryPage({
    super.key,
    required this.customerName,
    required this.phoneNumber,
    required this.vehicleType,
    required this.preferredLanguage,
  });

  @override
  State<VehicleDetailsSummaryPage> createState() =>
      _VehicleDetailsSummaryPageState();
}

class _VehicleDetailsSummaryPageState extends State<VehicleDetailsSummaryPage> {
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _vehicleMakeController = TextEditingController();
  final TextEditingController _odometerReadingController = TextEditingController();

  String? _selectedYear;
  String? _selectedModel;

  final Map<String, List<String>> _yearOptions = {
    'Car': ['2020', '2021', '2022', '2023', '2024'],
    'Bike': ['2018', '2019', '2020', '2021', '2022'],
    'Truck': ['2015', '2016', '2017', '2018', '2019'],
  };

  final Map<String, List<String>> _modelOptions = {
    'Car': ['Swift', 'i20', 'Verna', 'Creta'],
    'Bike': ['Pulsar', 'Apache', 'FZ', 'Duke'],
    'Truck': ['Eicher', 'Tata', 'Ashok Leyland'],
  };

  String normalizeVehicleType(String rawType) {
    final type = rawType.toLowerCase().trim();
    if (type.contains('car')) return 'Car';
    if (type.contains('bike')) return 'Bike';
    if (type.contains('truck')) return 'Truck';
    return 'Car'; // Default fallback
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _vehicleMakeController.dispose();
    _odometerReadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleType = normalizeVehicleType(widget.vehicleType);
    final modelList = _modelOptions[vehicleType] ?? [];
    final yearList = _yearOptions[vehicleType] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details Summary'),
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
            Text("Vehicle Type: $vehicleType", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            buildTextField(
              controller: _vehicleNumberController,
              label: 'Vehicle Number',
              hint: 'Enter vehicle number (e.g. AB12C3456)',
            ),
            buildTextField(
              controller: _vehicleMakeController,
              label: 'Vehicle Make',
              hint: 'Enter make (e.g. Ford)',
            ),
            buildDropdown(
              label: 'Vehicle Model',
              value: _selectedModel,
              items: modelList,
              onChanged: (value) => setState(() => _selectedModel = value),
            ),
            buildDropdown(
              label: 'Year',
              value: _selectedYear,
              items: yearList,
              onChanged: (value) => setState(() => _selectedYear = value),
            ),
            buildTextField(
              controller: _odometerReadingController,
              label: 'Odometer Reading',
              hint: 'Enter reading (e.g. 23456)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 16.0,
                  ),
                ),
                child: const Text(
                  'Save and Next',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNextPressed() {
    if (_vehicleMakeController.text.isEmpty ||
        _selectedModel == null ||
        _selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all vehicle fields')),
      );
      return;
    }

    final jobId = DateTime.now().millisecondsSinceEpoch.toString();
    final car = "$_selectedYear ${_vehicleMakeController.text} $_selectedModel";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DamageAssessmentPage(jobId: jobId, car: car),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
        ),
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

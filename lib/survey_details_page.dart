import 'package:flutter/material.dart';

class SurveyDetailsPage extends StatelessWidget {
  final String ownerName;
  final String vehicleName;
  final String vehicleYear;
  final String vehicleId;

  const SurveyDetailsPage({
    super.key,
    required this.ownerName,
    required this.vehicleName,
    required this.vehicleYear,
    required this.vehicleId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Details'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.blue.shade800],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Vehicle Information Card
                _buildInfoCard(
                  'Vehicle Information',
                  [
                    _buildInfoRow('Owner Name', ownerName),
                    _buildInfoRow('Vehicle', vehicleName),
                    _buildInfoRow('Year', vehicleYear),
                    _buildInfoRow('Vehicle ID', vehicleId),
                  ],
                ),
                const SizedBox(height: 16),

                // Customer Information Card
                _buildInfoCard(
                  'Customer Information',
                  [
                    _buildInfoRow('Customer Name', 'Jane Smith'),
                    _buildInfoRow('Phone Number', '+1 (555) 123-4567'),
                    _buildInfoRow('Preferred Language', 'English'),
                    _buildInfoRow('Email', 'jane.smith@email.com'),
                  ],
                ),
                const SizedBox(height: 16),

                // Damage Assessment Card
                _buildInfoCard(
                  'Damage Assessment',
                  [
                    _buildInfoRow('Assessment Date', 'August 8, 2025'),
                    _buildInfoRow('Damage Type', 'Front Bumper Damage'),
                    _buildInfoRow('Severity', 'Moderate'),
                    _buildInfoRow('Estimated Cost', '\$2,500 - \$3,500'),
                    _buildInfoRow('Repair Time', '3-5 business days'),
                  ],
                ),
                const SizedBox(height: 16),

                // Customer Interaction Log Card
                _buildInfoCard(
                  'Customer Interaction Log',
                  [
                    _buildInfoRow('Initial Contact', 'August 8, 2025 - 10:30 AM'),
                    _buildInfoRow('Service Request', 'Front bumper repair and paint'),
                    _buildInfoRow('Customer Notes', 'Customer mentioned minor accident in parking lot'),
                    _buildInfoRow('Follow-up Required', 'Schedule repair appointment'),
                  ],
                ),
                const SizedBox(height: 16),

                // Issue Categorization Card
                _buildInfoCard(
                  'Issue Categorization',
                  [
                    _buildInfoRow('Primary Issue', 'Body Damage'),
                    _buildInfoRow('Secondary Issue', 'Paint Damage'),
                    _buildInfoRow('Priority Level', 'Medium'),
                    _buildInfoRow('Category', 'Collision Repair'),
                  ],
                ),
                const SizedBox(height: 16),

                // Photos & Documents Card
                _buildPhotosCard(),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                                         Expanded(
                       child: ElevatedButton(
                         onPressed: () {
                           _showEditDialog(context);
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.orange,
                           foregroundColor: Colors.white,
                           padding: const EdgeInsets.symmetric(vertical: 16.0),
                         ),
                         child: const Text('Edit Survey'),
                       ),
                     ),
                     const SizedBox(width: 16),
                     Expanded(
                       child: ElevatedButton(
                         onPressed: () {
                           _showPrintDialog(context);
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.green,
                           foregroundColor: Colors.white,
                           padding: const EdgeInsets.symmetric(vertical: 16.0),
                         ),
                         child: const Text('Print Report'),
                       ),
                     ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
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
          Text(
            'Photos & Documents',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Damage Photos Section
          _buildPhotoSection(
            'Damage Photos',
            [
              _buildPhotoItem('Front Bumper Damage', Icons.car_crash, Colors.red),
              _buildPhotoItem('Side Panel Scratch', Icons.car_crash, Colors.orange),
              _buildPhotoItem('Rear Bumper Dent', Icons.car_crash, Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          
          // Vehicle Photos Section
          _buildPhotoSection(
            'Vehicle Photos',
            [
              _buildPhotoItem('Before Repair', Icons.car_rental, Colors.blue),
              _buildPhotoItem('After Repair', Icons.car_rental, Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          
          // Documents Section
          _buildPhotoSection(
            'Documents',
            [
              _buildPhotoItem('Insurance Policy', Icons.description, Colors.purple),
              _buildPhotoItem('Estimate Document', Icons.receipt, Colors.indigo),
              _buildPhotoItem('Work Order', Icons.assignment, Colors.teal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection(String title, List<Widget> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: photos,
        ),
      ],
    );
  }

  Widget _buildPhotoItem(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement photo/document viewer
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 10.0,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
             ),
     );
   }

   void _showEditDialog(BuildContext context) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Edit Survey'),
           content: const Text('This will open the survey in edit mode. All changes will be saved automatically.'),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: const Text('Cancel'),
             ),
             ElevatedButton(
               onPressed: () {
                 Navigator.of(context).pop();
                 _navigateToEditMode(context);
               },
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.orange,
                 foregroundColor: Colors.white,
               ),
               child: const Text('Edit'),
             ),
           ],
         );
       },
     );
   }

   void _showPrintDialog(BuildContext context) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Print Report'),
           content: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text('Choose print options:'),
               const SizedBox(height: 16),
               _buildPrintOption('Full Report', 'Complete survey with all details'),
               _buildPrintOption('Summary Only', 'Basic vehicle and damage information'),
               _buildPrintOption('Photos Only', 'Just the photos and documents'),
             ],
           ),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: const Text('Cancel'),
             ),
             ElevatedButton(
               onPressed: () {
                 Navigator.of(context).pop();
                 _printReport(context, 'Full Report');
               },
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.green,
                 foregroundColor: Colors.white,
               ),
               child: const Text('Print'),
             ),
           ],
         );
       },
     );
   }

   Widget _buildPrintOption(String title, String description) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 8.0),
       child: Row(
         children: [
           Radio<String>(
             value: title,
             groupValue: 'Full Report', // Default selection
             onChanged: (value) {
               // TODO: Handle selection
             },
           ),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   title,
                   style: const TextStyle(
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 Text(
                   description,
                   style: const TextStyle(
                     fontSize: 12.0,
                     color: Colors.grey,
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
   }

   void _navigateToEditMode(BuildContext context) {
     // TODO: Navigate to edit mode
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text('Edit mode activated! Survey is now editable.'),
         backgroundColor: Colors.orange,
       ),
     );
   }

   void _printReport(BuildContext context, String reportType) {
     // TODO: Implement actual printing
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('$reportType is being prepared for printing...'),
         backgroundColor: Colors.green,
       ),
     );
   }
}

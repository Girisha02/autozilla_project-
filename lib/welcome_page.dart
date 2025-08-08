import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garage Management System'),
        actions: const [
          Row(
            children: [
              Icon(Icons.account_circle, size: 30.0),
              SizedBox(width: 8),
              Text('John Smith', style: TextStyle(fontSize: 16.0)),
              SizedBox(width: 16),
            ],
          ),
        ],
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
                  ElevatedButton(
                    onPressed: () {
                      context.push('/vehicle-detail');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('New Vehicle Survey'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/view-existing-surveys');
                    },
                    child: const Text('View Existing Surveys'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement Sync / Upload functionality
                    },
                    child: const Text('Sync / Upload Offline Data'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

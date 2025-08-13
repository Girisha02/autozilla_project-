import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Garage Management System',
          style: TextStyle(fontSize: 16.0), // Decreased font size
        ),
        // Removed actions from AppBar
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(Icons.account_circle, size: 20.0, color: Colors.white),
                  SizedBox(width: 8),
                  Text('John Smith', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.push('/vehicle-detail');
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                              (states) => states.contains(MaterialState.pressed) ? Colors.orange : null,
                            ),
                          ),
                          child: const Text('New Vehicle Survey'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.push('/view-existing-surveys');
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                              (states) => states.contains(MaterialState.pressed) ? Colors.orange : null,
                            ),
                          ),
                          child: const Text('View Existing Surveys'),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement Sync / Upload functionality
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                              (states) => states.contains(MaterialState.pressed) ? Colors.orange : null,
                            ),
                          ),
                          child: const Text('Sync / Upload Offline Data'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

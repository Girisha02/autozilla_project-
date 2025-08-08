import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:myapp/welcome_page.dart';
import 'package:myapp/vehicle_detail_page.dart';
import 'package:myapp/vehicle_details_summary_page.dart';
import 'package:myapp/damage_assesment_page.dart';
import 'package:myapp/damage_summary_page.dart';
import 'package:myapp/customer_interaction_log_page.dart';
import 'package:myapp/issue_categorization_page.dart';
import 'package:myapp/upload_data_page.dart';
import 'package:myapp/view_existing_surveys_page.dart';
import 'package:myapp/survey_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// Define the GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/welcome', builder: (context, state) => WelcomePage()),
    GoRoute(
      path: '/view-existing-surveys',
      builder: (context, state) => const ViewExistingSurveysPage(),
    ),
    GoRoute(
      path: '/survey-details',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        return SurveyDetailsPage(
          ownerName: params?['ownerName']?.toString() ?? '',
          vehicleName: params?['vehicleName']?.toString() ?? '',
          vehicleYear: params?['vehicleYear']?.toString() ?? '',
          vehicleId: params?['vehicleId']?.toString() ?? '',
        );
      },
    ),
    GoRoute(
      path: '/vehicle-detail',
      builder: (context, state) => const VehicleDetailPage(),
    ),
    GoRoute(
      path: '/vehicle-details-summary',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        return VehicleDetailsSummaryPage(
          customerName: params?['customerName']?.toString() ?? '',
          phoneNumber: params?['phoneNumber']?.toString() ?? '',
          vehicleType: params?['vehicleType']?.toString() ?? '',
          preferredLanguage: params?['preferredLanguage']?.toString() ?? '',
          isExistingSurvey: params?['isExistingSurvey'] ?? false,
          vehicleYear: params?['vehicleYear']?.toString(),
          vehicleId: params?['vehicleId']?.toString(),
          capturedImages: params?['capturedImages'] as Map<String, List<File>>?,
        );
      },
    ),
    GoRoute(
      path: '/damage-assessment',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        return DamageAssessmentPage(
          jobId: params?['jobId']?.toString() ?? '',
          car: params?['car']?.toString() ?? '',
          customerName: params?['customerName']?.toString() ?? '',
          capturedImages: params?['capturedImages'] as Map<String, List<File>>?,
          existingDamages:
              params?['existingDamages'] as List<Map<String, String>>?,
        );
      },
    ),
    GoRoute(
      path: '/damage-summary',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        return DamageSummaryPage(
          jobId: params?['jobId']?.toString() ?? '',
          car: params?['car']?.toString() ?? '',
          damage: params?['damage']?.toString() ?? '',
          damageType: params?['damageType']?.toString() ?? '',
          customerName: params?['customerName']?.toString() ?? '',
          capturedImages: params?['capturedImages'] as Map<String, List<File>>?,
          allDamages: params?['allDamages'] as List<Map<String, String>>?,
        );
      },
    ),
    GoRoute(
      path: '/customer-interaction-log',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        return CustomerInteractionLogPage(
          customerName: params?['customerName']?.toString() ?? '',
          capturedImages: params?['capturedImages'] as Map<String, List<File>>?,
        );
      },
    ),
    GoRoute(
      path: '/issue-categorization',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        return IssueCategorizationPage(
          capturedImages: params?['capturedImages'] as Map<String, List<File>>?,
          vehicleRegNo: params?['vehicleRegNo']?.toString(),
          vehicleModel: params?['vehicleModel']?.toString(),
          claimNo: params?['claimNo']?.toString(),
        );
      },
    ),
    GoRoute(
      path: '/upload-data',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        final allIssues =
            params?['allIssues'] as List<Map<String, dynamic>>? ?? [];
        return UploadDataPage(
          allIssues: allIssues,
          capturedImages: params?['capturedImages'] as Map<String, List<File>>?,
        );
      },
    ),
  ],
);

// LOGIN PAGE
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showErrorBanner = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _showErrorBanner = true;
      });
    } else {
      setState(() {
        _showErrorBanner = false;
      });
      // You can add real auth logic here
      context.push('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade800],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_showErrorBanner)
                    Container(
                      width: double.infinity,
                      color: Colors.red,
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(
                        child: Text(
                          'Please enter the email and password',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Email or Phone Number*',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password*',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.black),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password functionality
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  ElevatedButton(onPressed: _login, child: const Text('Login')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

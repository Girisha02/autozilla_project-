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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E40AF), // Deep blue
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E40AF),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1E40AF),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1E40AF), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
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
  bool _obscurePassword = true;

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
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3B82F6), // Light blue
              Color(0xFF1E40AF), // Deep blue
              Color(0xFF1E3A8A), // Darker blue
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Title
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.car_repair,
                          size: 48,
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Autorox',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Vehicle Survey System',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  if (_showErrorBanner)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Please enter the email and password',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  
                  // Email Field
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Email or Phone Number*',
                      hintStyle: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Field
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password*',
                      hintStyle: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF6B7280),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF6B7280),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 14,
                    ),
                    obscureText: _obscurePassword,
                  ),
                  const SizedBox(height: 8),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password functionality
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E40AF),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.2),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Footer Text
                  const Text(
                    'Secure access to your vehicle survey data',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
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

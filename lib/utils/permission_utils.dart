// lib/utils/permission_utils.dart
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.storage,
    Permission.photos, // iOS only, will be ignored on Android
  ].request();
}
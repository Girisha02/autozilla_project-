import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraCaptureScreen extends StatefulWidget {
  final String direction;
  const CameraCaptureScreen({super.key, required this.direction});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controller = CameraController(camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _takePicture() async {
    await _initializeControllerFuture;
    final image = await _controller!.takePicture();
    setState(() {
      _imageFile = File(image.path);
    });
  }

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture ${widget.direction} Image')),
      body: Column(
        children: [
          Expanded(
            child:
                _imageFile != null
                    ? Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                    : FutureBuilder(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CameraPreview(_controller!);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: _pickFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
              ElevatedButton.icon(
                onPressed: _takePicture,
                icon: const Icon(Icons.camera),
                label: const Text('Capture'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (_imageFile != null) {
                    Navigator.pop(context, _imageFile);
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Done'),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  double _currentZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onInteractionUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentZoom *= details.scale.clamp(0.5, 2.0);
      _controller.setZoomLevel(_currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            //! Handle the settings icon onPressed event
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                  onScaleUpdate: _onInteractionUpdate,
                  child: InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(0),
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: CameraPreview(_controller),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

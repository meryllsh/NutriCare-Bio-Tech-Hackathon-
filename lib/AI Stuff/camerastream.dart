import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

class CameraStream extends StatefulWidget {
  const CameraStream({super.key});

  @override
  State<CameraStream> createState() => _CameraStreamState();
}

class _CameraStreamState extends State<CameraStream> {
  late CameraController _cameraController;
  late tfl.Interpreter _interpreter;
  bool _isDetecting = false;
  String _predictedLabel = '';
  double _confidence = 0.0;
  List<String> labels = [];
  Timer? _timer;
  int _frameCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
    _loadLabels();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _interpreter.close();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    _cameraController.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _isDetecting = true;
        _runModelOnFrame(image);
      }
    });
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset('assets/foodpretrainedmodel.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> _loadLabels() async {
    final labelData = await rootBundle.loadString('assets/foodpretrainedmodel.csv');
    labels = labelData.split('\n').skip(1).map((label) => label.trim()).toList();
    print('Labels loaded: $labels');
  }

  Future<void> _runModelOnFrame(CameraImage image) async {
    try {
      final input = _preprocessCameraImage(image);
      final output = List.filled(1 * 2024, 0).reshape([1, 2024]);
      _interpreter.run(input, output);

      final cleanedOutput = output[0].map((e) => e.toDouble()).toList();
      double maxValue = double.negativeInfinity;
      int maxIndex = -1;

      for (int i = 0; i < cleanedOutput.length; i++) {
        if (cleanedOutput[i] > maxValue) {
          maxValue = cleanedOutput[i];
          maxIndex = i;
        }
      }

      setState(() {
        _predictedLabel = maxValue > 50.0 ? labels[maxIndex] : 'nothing detected';
        _confidence = maxValue;
      });
      print('Highest index: $maxIndex, Label: ${labels[maxIndex]}, Confidence: $maxValue');
    } catch (e) {
      print('Error running model on frame: $e');
    } finally {
      _isDetecting = false;
    }
  }

  List<List<List<List<int>>>> _preprocessCameraImage(CameraImage image) {
    final img.Image convertedImage = _convertCameraImage(image);
    final img.Image resizedImage = img.copyResize(convertedImage, width: 224, height: 224);
    final input = List.generate(1, (i) => List.generate(224, (j) => List.generate(224, (k) => List.generate(3, (l) => 0))));

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = img.getRed(pixel);
        input[0][y][x][1] = img.getGreen(pixel);
        input[0][y][x][2] = img.getBlue(pixel);
      }
    }

    return input;
  }

  img.Image _convertCameraImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final img.Image imgImage = img.Image(width, height);

    for (int i = 0; i < image.planes.length; i++) {
      final plane = image.planes[i];
      final bytes = plane.bytes;
      final int rowStride = plane.bytesPerRow;
      final int pixelStride = plane.bytesPerPixel ?? 1;

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int index = y * rowStride + x * pixelStride;
          if (index < bytes.length) {
            final int pixel = bytes[index];
            imgImage.setPixel(x, y, img.getColor(pixel, pixel, pixel));
          }
        }
      }
    }

    return imgImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Object Detection'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _cameraController.value.isInitialized
                ? CameraPreview(_cameraController)
                : Center(child: CircularProgressIndicator()),
          ),
          Text(
            'Predicted Label: $_predictedLabel (Confidence: $_confidence)',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
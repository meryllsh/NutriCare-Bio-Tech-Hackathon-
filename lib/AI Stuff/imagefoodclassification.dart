import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
class FoodClassification extends StatefulWidget {
  const FoodClassification({super.key});

  @override
  State<FoodClassification> createState() => _FoodClassificationState();
}

class _FoodClassificationState extends State<FoodClassification> {
  @override
  void initState() {
    super.initState();
    _initTensorFlow();
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  Future<void> _initTensorFlow() async {
    try {
      final interpreter = await tfl.Interpreter.fromAsset('assets/your_model.tflite');
      print('Model loaded successfully: $res');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> FileImageRecognition() async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: 'assets/mangostickyrice.jpg',
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true,
      );
      print(recognitions);
    } catch (e) {
      print('Failed to run model on image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Classification'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: FileImageRecognition,
          child: Text('Run Model'),
        ),
      ),
    );
  }
}
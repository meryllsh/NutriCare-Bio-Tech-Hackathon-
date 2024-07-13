import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:io';

class FoodClassification extends StatefulWidget {
  const FoodClassification({super.key});

  @override
  State<FoodClassification> createState() => _FoodClassificationState();
}

class _FoodClassificationState extends State<FoodClassification> {
  late tfl.Interpreter interpreter;

  @override
  void initState() {
    super.initState();
    _initTensorFlow();
  }

  @override
  void dispose() {
    interpreter.close();
    super.dispose();
  }

  Future<void> _initTensorFlow() async {
    try {
      interpreter = await tfl.Interpreter.fromAsset('assets/your_model.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<void> FileImageRecognition() async {
    try {
      // Load the image from assets
      ByteData imageData = await rootBundle.load('assets/mangostickyrice.jpg');
      Uint8List imageBytes = imageData.buffer.asUint8List();
      img.Image image = img.decodeImage(imageBytes)!;

      // Preprocess the image to match the input tensor shape and type
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
      var input = List.generate(1, (i) => List.generate(224, (j) => List.generate(224, (k) => List.generate(3, (l) => 0.0))));
      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          var pixel = resizedImage.getPixel(x, y);
          input[0][y][x][0] = img.getRed(pixel) / 255.0;
          input[0][y][x][1] = img.getGreen(pixel) / 255.0;
          input[0][y][x][2] = img.getBlue(pixel) / 255.0;
        }
      }

      // Define output tensor with shape [1, 2] and type float32
      var output = List.filled(1 * 2, 0).reshape([1, 2]);

      // Run inference
      interpreter.run(input, output);

      // Print the output
      print(output);
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
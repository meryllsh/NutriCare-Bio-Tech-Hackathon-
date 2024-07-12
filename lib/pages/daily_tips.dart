import 'package:flutter/material.dart';

class DailyTips extends StatefulWidget {
  const DailyTips({Key? key}) : super(key: key);

  @override
  _DailyTipsState createState() => _DailyTipsState();
}

class _DailyTipsState extends State<DailyTips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Daily Tips'),
      ),
    );
  }
}
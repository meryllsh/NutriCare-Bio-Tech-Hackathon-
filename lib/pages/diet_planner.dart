import 'package:flutter/material.dart';

class DietPlanner extends StatefulWidget {
  const DietPlanner({Key? key}) : super(key: key);

  @override
  _DietPlannerState createState() => _DietPlannerState();
}

class _DietPlannerState extends State<DietPlanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Diet_planner'),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white,
      label: Text(
        'SanD',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

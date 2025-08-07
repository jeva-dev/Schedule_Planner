import 'package:flutter/material.dart';


class TestImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/home.png'),
      ),
    );
  }
}

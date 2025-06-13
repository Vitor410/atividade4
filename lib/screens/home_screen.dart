import 'package:flutter/material.dart';
import 'collections_home_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coleções"),
      ),
      body: CollectionsHomeScreen(),
    );
  }
}

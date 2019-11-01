import 'ar_object.dart';
import 'package:flutter/material.dart';
import 'augmented_face.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DevFest Pescara'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('AR Objects'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ARObjectScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Augmented Face'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AugmentedFaceScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARObjectScreen extends StatefulWidget {
  @override
  _AugmentedFaceScreenState createState() => _AugmentedFaceScreenState();
}

class _AugmentedFaceScreenState extends State<ARObjectScreen> {
  ArCoreController _arCoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Augmented Face'),
      ),
      body: Stack(
        children: <Widget>[
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    _arCoreController = controller;
    _arCoreController.onNodeTap = (name) => onTapHandler(name);
    _arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  Future _addSphere(ArCoreHitTestResult plane) async {
    final moonMaterial = ArCoreMaterial(color: Colors.grey);

    final moonShape = ArCoreSphere(
      materials: [moonMaterial],
      radius: 0.03,
    );

    final moon = ArCoreNode(
      shape: moonShape,
      position: vector.Vector3(0.2, 0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );

    final ByteData textureBytes = await rootBundle.load('assets/earth.jpg');

    final earthMaterial = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());

    final earthShape = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.1,
    );

    final earth = ArCoreNode(
        shape: earthShape,
        children: [moon],
        position: plane.pose.translation + vector.Vector3(0.0, 1.0, 0.0),
        rotation: plane.pose.rotation);

    _arCoreController.addArCoreNodeWithAnchor(earth);
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addSphere(hit);
  }

  void onTapHandler(String name) {
    print("Flutter: onNodeTap");
    showDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(content: Text('onNodeTap on $name')),
    );
  }

  @override
  void dispose() {
    _arCoreController.dispose();
    super.dispose();
  }
}

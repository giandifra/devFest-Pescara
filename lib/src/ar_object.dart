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

  // Metodo invocato dopo che la view nativa è stata creata
  void _onArCoreViewCreated(ArCoreController controller) {
    _arCoreController = controller;
    _arCoreController.onNodeTap = (name) => onTapHandler(name);
    _arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  Future _addEarthWithMoon(ArCoreHitTestResult plane) async {
    // Stile della luna
    final moonMaterial = ArCoreMaterial(color: Colors.grey);

    // Sfera che rappresenta la luna
    final moonShape = ArCoreSphere(
      materials: [moonMaterial],
      radius: 0.03,
    );

    // Nodo relativo alla luna
    final moon = ArCoreNode(
      shape: moonShape,
      position: vector.Vector3(0.2, 0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );

    // Carico dagli assets la texture della terra
    final ByteData textureBytes = await rootBundle.load('assets/earth.jpg');

    // Stile della terra
    final earthMaterial = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());

    // Sfera che rappresenta la terra
    final earthShape = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.1,
    );

    // Nodo relativo alla terra
    // Il nodo luno è figlio del nodo terra quindi la sua
    // posizione sarà relativa a quella del nodo padre (terra)
    final earth = ArCoreNode(
        shape: earthShape,
        children: [moon],
        position: plane.pose.translation + vector.Vector3(0.0, 1.0, 0.0),
        rotation: plane.pose.rotation);

    // Ancoro il nodo al piano rilevato
    _arCoreController.addArCoreNodeWithAnchor(earth);
  }

  // Metodo invocato ad ogni tap sul piano rilevato
  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addEarthWithMoon(hit);
  }

  // Metodo invocato quando viene tappato un nodo
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

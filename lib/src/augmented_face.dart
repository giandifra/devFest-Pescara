import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AugmentedFaceScreen extends StatefulWidget {
  @override
  _AugmentedFaceScreenState createState() => _AugmentedFaceScreenState();
}

class _AugmentedFaceScreenState extends State<AugmentedFaceScreen> {
  ArCoreFaceController _arCoreFaceController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Augmented Face'),
      ),
      body: Stack(
        children: <Widget>[
          ArCoreFaceView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableAugmentedFaces: true,
          ),
        ],
      ),
    );
  }

  // Metodo invocato dopo che la view nativa è stata creata
  void _onArCoreViewCreated(ArCoreFaceController controller) {
    _arCoreFaceController = controller;
    loadMesh();
  }

  // Carico la texture e indico il nome del file 3D da abbinare al viso
  void loadMesh() async {
    final ByteData textureBytes =
        await rootBundle.load('assets/fox_face_mesh_texture.png');

    _arCoreFaceController.loadMesh(
        textureBytes: textureBytes.buffer.asUint8List(),
        skin3DModelFilename: 'fox_face.sfb');
  }

  @override
  void dispose() {
    _arCoreFaceController.dispose();
    super.dispose();
  }
}

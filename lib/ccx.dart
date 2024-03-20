import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'main.dart';

class XApp extends StatefulWidget {
  @override
  _XAppState createState() => _XAppState();
}

class _XAppState extends State<XApp> {
  CameraController? cameraController;
  CameraImage? imgCamera;
  bool isWorking = false;
  double? imgHeight;
  double? imgWidth;
  List? recognitionsList;

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        print("No cameras available");
        return;
      }

      cameraController = CameraController(cameras![0], ResolutionPreset.medium);
      await cameraController!.initialize();

      if (!mounted) {
        return;
      }

      setState(() {
        if (cameraController!.value.isInitialized) {
          cameraController!.startImageStream((imageFromStream) {
            if (!isWorking) {
              isWorking = true;
              imgCamera = imageFromStream;
              runModelOnStreamFrame();
            }
          });
        }
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> runModelOnStreamFrame() async {
    if (imgCamera == null) return;

    imgHeight = imgCamera!.height + 0.0;
    imgWidth = imgCamera!.width + 0.0;

    recognitionsList = await Tflite.detectObjectOnFrame(
      bytesList: imgCamera!.planes.map((plane) {
        return plane.bytes;
      }).toList(),

      imageHeight: imgCamera!.height,
      imageWidth: imgCamera!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    isWorking = false;

    setState(() {
      imgCamera;
    });
  }

  Future<void> loadModel() async {
    Tflite.close();

    try {
      var response;
      response = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      print(response);
    } on PlatformException catch (e) {
      print("Error loading model: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (cameraController != null) {
      cameraController!.stopImageStream();
    }
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();

    // Load the model first before initializing the camera
    loadModel().then((_) {
      initCamera();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (recognitionsList == null) return [];

    if (imgHeight == null || imgWidth == null) return [];

    double factorX = screen.width;
    double factorY = imgHeight!;

    Color colorPick = Colors.pink;

    return recognitionsList!.map((result) {
      return Positioned(
        left: result["rect"]["x"] * factorX,
        top: result["rect"]["y"] * factorY,
        width: result["rect"]["w"] * factorX,
        height: result["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildrenWidgets = [];

    stackChildrenWidgets.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: size.width,
        height: size.height - 100,
        child: Container(
          height: size.height - 100,
          child: (cameraController != null && cameraController!.value.isInitialized)
              ? AspectRatio(
            aspectRatio: cameraController!.value.aspectRatio,
            child: CameraPreview(cameraController!),
          )
              : Container(),
        ),
      ),
    );

    if (imgCamera != null) {
      stackChildrenWidgets.addAll(displayBoxesAroundRecognizedObjects(size));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: stackChildrenWidgets,
          ),
        ),
      ),
    );
  }
}

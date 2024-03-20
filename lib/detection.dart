// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:tflite_v2/tflite_v2.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
//
//
//
// const String ssd = "SSD MobileNet";
// const String yolo = "Tiny YOLOv2";
//
//
//
// class TfliteHome extends StatefulWidget {
//   @override
//   _TfliteHomeState createState() => _TfliteHomeState();
// }
//
// class _TfliteHomeState extends State<TfliteHome> {
//   String _model = ssd;
//   File ?_image;
//   double? _imageWidth;
//   double? _imageHeight;
//   bool _busy = false;
//   List ?_recognitions;
//
//   @override
//   void initState() {
//     super.initState();
//     _busy = true;
//
//     loadModel().then((val) {
//       setState(() {
//         _busy = false;
//       });
//     });
//   }
//
//   loadModel() async {
//     Tflite.close();
//     try {
//       String? res;
//       if (_model == yolo) {
//         res = await Tflite.loadModel(
//           model: "assets/model.tflite",
//           labels: "assets/labels.txt",
//         );
//       } else {
//         res = await Tflite.loadModel(
//           model: "assets/model.tflite",
//           labels: "assets/labels.txt",
//         );
//       }
//       print(res);
//     } on PlatformException {
//       print("Failed to load the model");
//     }
//   }
//
//   selectFromImagePicker() async {
//     var image = await ImagePicker().pickImage(source: ImageSource.gallery);
//
//     if (image == null) return;
//     setState(() {
//       _busy = true;
//     });
//     predictImage(image as File);
//   }
//
//   predictImage(File image) async {
//     if (image == null) return;
//
//     if (_model == yolo) {
//       await yolov2Tiny(image);
//     } else {
//       await ssdMobileNet(image);
//     }
//
//     FileImage(image)
//         .resolve(ImageConfiguration())
//         .addListener((ImageStreamListener((ImageInfo info, bool _) {
//       setState(() {
//         _imageWidth = info.image.width.toDouble();
//         _imageHeight = info.image.height.toDouble();
//       });
//     })));
//
//     setState(() {
//       _image = image;
//       _busy = false;
//     });
//   }
//
//   yolov2Tiny(File image) async {
//     var recognitions = await Tflite.detectObjectOnImage(
//         path: image.path,
//
//         threshold: 0.3,
//         imageMean: 0.0,
//         imageStd: 255.0,
//         numResultsPerClass: 1);
//
//     setState(() {
//       _recognitions = recognitions;
//     });
//   }
//
//   ssdMobileNet(File image) async {
//     var recognitions = await Tflite.detectObjectOnImage(
//         path: image.path, numResultsPerClass: 1);
//
//     setState(() {
//       _recognitions = recognitions;
//     });
//   }
//
//   List<Widget> renderBoxes(Size screen) {
//     if (_recognitions == null) return [];
//     if (_imageWidth == null || _imageHeight == null) return [];
//
//     double factorX = screen.width;
//     double factorY = _imageHeight != null && _imageHeight! > 0.0
//         ? _imageHeight! / _imageHeight! * screen.width
//         : 0.0;
//     Color blue = Colors.red;
//
//     return _recognitions!.map((re) {
//       return Positioned(
//         left: re["rect"]["x"] * factorX,
//         top: re["rect"]["y"] * factorY,
//         width: re["rect"]["w"] * factorX,
//         height: re["rect"]["h"] * factorY,
//         child: Container(
//           decoration: BoxDecoration(
//               border: Border.all(
//                 color: blue,
//                 width: 3,
//               )),
//           child: Text(
//             "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
//             style: TextStyle(
//               background: Paint()..color = blue,
//               color: Colors.white,
//               fontSize: 15,
//             ),
//           ),
//         ),
//       );
//     }).toList() ??[];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     List<Widget> stackChildren = [];
//
//     stackChildren.add(Positioned(
//       top: 0.0,
//       left: 0.0,
//       width: size.width,
//       child: _image == null ? Text("No Image Selected") : Image.file(_image!),
//     ));
//
//     stackChildren.addAll(renderBoxes(size));
//
//     if (_busy) {
//       stackChildren.add(Center(
//         child: CircularProgressIndicator(),
//       ));
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("TFLite Demo"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.image),
//         tooltip: "Pick Image from gallery",
//         onPressed: selectFromImagePicker,
//       ),
//       body: Stack(
//         children: stackChildren,
//       ),
//     );
//   }
// }

// here is  image based dection /but live should be there
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tesarcat/main.dart';
import 'package:tflite_v2/tflite_v2.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadmodel();
  }

  loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true);
      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Currency Detection App')),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: !cameraController!.value.isInitialized
                ? Container()
                : AspectRatio(
              aspectRatio: cameraController!.value.aspectRatio,
              child: CameraPreview(cameraController!),
            ),
          ),
        ),
        Text(
          output,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )
      ]),
    );
  }
}
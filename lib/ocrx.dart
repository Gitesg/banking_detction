// // import 'dart:async';
// // import 'dart:typed_data';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'dart:io';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // import 'package:camera/camera.dart';
// //
// // class MyHomePagex extends StatefulWidget {
// //   MyHomePagex({Key? key}) : super(key: key);
// //
// //   @override
// //   _MyHomePageStatex createState() => _MyHomePageStatex();
// // }
// //
// // class _MyHomePageStatex extends State<MyHomePagex> {
// //   String _ocrText = '';
// //   bool bload = false;
// //   bool bDownloadtessFile = false;
// //   var LangList = ["eng"];
// //   var selectList = ["eng"];
// //   String path = "";
// //   FlutterTts flutterTts = FlutterTts();
// //   late CameraController _cameraController;
// //   late List<CameraDescription> cameras;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initializeCamera();
// //   }
// //
// //   Future<void> initializeCamera() async {
// //     cameras = await availableCameras();
// //     _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
// //     await _cameraController.initialize();
// //   }
// //
// //   Future<void> disposeCamera() async {
// //     await _cameraController.dispose();
// //   }
// //
// //   Future<void> writeToFile(ByteData data, String path) {
// //     final buffer = data.buffer;
// //     return File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
// //   }
// //
// //   Future<void> _speak() async {
// //     await flutterTts.setLanguage("en-US");
// //     await flutterTts.setPitch(1.0);
// //     await flutterTts.speak(_ocrText);
// //   }
// //
// //   void runFilePicker() async {
// //     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
// //
// //     if (pickedFile != null) {
// //       _ocr(pickedFile.path);
// //     }
// //   }
// //
// //   void runCameraCapture() async {
// //     XFile? picture = await _cameraController.takePicture();
// //     if (picture != null) {
// //       _ocr(picture.path);
// //     }
// //   }
// //
// //   void _ocr(String imagePath) async {
// //     if (selectList.isEmpty) {
// //       print("Please select a language");
// //       return;
// //     }
// //
// //     path = imagePath;
// //
// //     var langs = selectList.join("+");
// //
// //     setState(() {
// //       bload = true;
// //     });
// //
// //     _ocrText = await FlutterTesseractOcr.extractText(path, language: langs, args: {"preserve_interword_spaces": "1"});
// //
// //     setState(() {
// //       bload = false;
// //     });
// //
// //     // Speak the extracted text
// //     _speak();
// //   }
// //
// //   @override
// //   void dispose() {
// //     disposeCamera();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("OCR App"),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: [
// //             Row(
// //
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //
// //                 // Padding(
// //                 //   padding: EdgeInsets.all(8.0), // Adjust the padding as needed
// //                 //   child: ElevatedButton(
// //                 //     onPressed: runFilePicker,
// //                 //     child: Text("Pick Image from File"),
// //                 //   ),
// //                 // ),
// //                 // SizedBox(width: 16), // Adjust the width as needed
// //                 // // Padding(
// //                 //   padding: EdgeInsets.all(8.0), // Adjust the padding as needed
// //                 //   child: ElevatedButton(
// //                 //     onPressed: runCameraCapture,
// //                 //     child: Text("Capture Image from Camera"),
// //                 //   ),
// //                 // ),
// //
// //               // Adjust the padding as needed
// //                  ElevatedButton(
// //                     onPressed: runFilePicker,
// //                     child: Text("Pick Image from File"),),
// //
// //
// //  //                SizedBox(width: 5), // Adjust the width as needed
// //  // ElevatedButton(
// //  //                    onPressed: runCameraCapture,
// //  //                    child: Text("Capture Image from Camera"),
// //  //
// //  //                ),
// //               ],
// //             ),
// //             SizedBox(height: 16),
// //             Row(
// //               children: [
// //                 ...LangList.map((e) => Row(
// //                   children: [
// //                     Checkbox(
// //                       value: selectList.contains(e),
// //                       onChanged: (v) async {
// //                         if (!kIsWeb) {
// //                           Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
// //                           if (!dir.existsSync()) {
// //                             dir.create();
// //                           }
// //
// //                           bool isInstalled = dir.listSync().any((element) => element.path.endsWith('$e.traineddata'));
// //
// //                           if (!isInstalled) {
// //                             setState(() {
// //                               bDownloadtessFile = true;
// //                             });
// //
// //                             HttpClient httpClient = HttpClient();
// //                             HttpClientRequest request =
// //                             await httpClient.getUrl(Uri.parse('https://github.com/tesseract-ocr/tessdata/raw/main/${e}.traineddata'));
// //                             HttpClientResponse response = await request.close();
// //                             Uint8List bytes = await consolidateHttpClientResponseBytes(response);
// //                             String dir = await FlutterTesseractOcr.getTessdataPath();
// //                             print('$dir/${e}.traineddata');
// //                             File file = File('$dir/${e}.traineddata');
// //                             await file.writeAsBytes(bytes);
// //
// //                             setState(() {
// //                               bDownloadtessFile = false;
// //                             });
// //                           }
// //                         }
// //
// //                         setState(() {
// //                           if (selectList.contains(e)) {
// //                             selectList.remove(e);
// //                           } else {
// //                             selectList.add(e);
// //                           }
// //                         });
// //                       },
// //                     ),
// //                     Text(e),
// //                   ],
// //                 )),
// //               ],
// //             ),
// //             Expanded(
// //               child: ListView(
// //                 children: [
// //                   if (path.isNotEmpty)
// //                     Image.file(File(path)),
// //                   if (bload) CircularProgressIndicator(),
// //                   Text(_ocrText),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: kIsWeb
// //           ? Container()
// //           : FloatingActionButton(
// //         onPressed: runFilePicker,
// //         tooltip: 'Pick Image',
// //         child: Icon(Icons.add),
// //       ),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// //     );
// //   }
// // }
// //
// ////
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// class Sumz extends StatefulWidget {
//   const Sumz({Key? key}) : super(key: key);
//
//   @override
//   State<Sumz> createState() => _SumzState();
// }
//
// class _SumzState extends State<Sumz> {
//   final TextRecognizer _textRecognizer = TextRecognizer();
//   final FlutterTts flutterTts = FlutterTts();
//   bool textScanning = false;
//   XFile? imageFile;
//   String scannedText = "";
//
//   @override
//   void initState() {
//     super.initState();
//     // initTts();
//   }
//   Future<void> speakText() async {
//     await flutterTts.setLanguage('en-US');
//     await flutterTts.setSpeechRate(0.5);
//     print("Text to be spoken: $scannedText");
//     try {
//       await flutterTts.speak(scannedText);
//       print("Text spoken successfully");
//     } catch (e) {
//       print("Error while speaking: $e");
//     }
//   }
//   // Future<void> initTts() async {
//   //   await flutterTts.setLanguage('en-US');
//   //   await flutterTts.setSpeechRate(0.5);
//   // }
//
//   @override
//   void dispose() async {
//     _textRecognizer.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Text Detection'),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Colors.orange[100],
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               if (textScanning) const CircularProgressIndicator(),
//               if (!textScanning && imageFile == null)
//                 Container(
//                   width: 300,
//                   height: 300,
//                   color: Colors.grey[300]!,
//                 ),
//               if (imageFile != null) Image.file(File(imageFile!.path)),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     padding: const EdgeInsets.only(top: 10),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.white,
//                         onPrimary: Colors.grey,
//                         shadowColor: Colors.grey[400],
//                         elevation: 10,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       onPressed: () {
//                         getImage(ImageSource.gallery);
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(
//                           vertical: 5,
//                           horizontal: 5,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(
//                               Icons.image,
//                               size: 30,
//                             ),
//                             Text(
//                               "Gallery",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[600],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     padding: const EdgeInsets.only(top: 10),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.white,
//                         onPrimary: Colors.grey,
//                         shadowColor: Colors.blueAccent,
//                         elevation: 10,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                       onPressed: () {
//                         getImage(ImageSource.camera);
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(
//                           vertical: 5,
//                           horizontal: 5,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(
//                               Icons.camera_alt,
//                               size: 30,
//                             ),
//                             Text(
//                               "Camera",
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey[600],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 scannedText,
//                 style: const TextStyle(fontSize: 20),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void getImage(ImageSource source) async {
//     try {
//       final pickedImage = await ImagePicker().pickImage(source: source);
//       if (pickedImage != null) {
//         textScanning = true;
//         imageFile = pickedImage;
//         setState(() {});
//         getRecognisedText(pickedImage);
//       }
//     } catch (e) {
//       textScanning = false;
//       imageFile = null;
//       scannedText = "Error occurred while scanning";
//       setState(() {});
//     }
//   }
//
//   void getRecognisedText(XFile image) async {
//     final inputImage = InputImage.fromFilePath(image.path);
//     final recognizedText = await _textRecognizer.processImage(inputImage);
//
//     scannedText = "";
//     for (TextBlock block in recognizedText.blocks) {
//       for (TextLine line in block.lines) {
//         scannedText = scannedText + line.text + "\n";
//       }
//     }
//     textScanning = false;
//     setState(() {});
//
//     await speakText();
//   }
//
//
// }

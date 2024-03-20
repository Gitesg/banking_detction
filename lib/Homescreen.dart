// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'package:image_picker/image_picker.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   bool _isScanning = false;
//   String _extractedText = "";
//   FileImage? fl;
//   String  x=" ";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(centerTitle: true, title: Text("Extract Text")),
//       body: ListView(
//         children: [
//           fl == null
//               ? Container(
//             height: 300,
//             color: Colors.grey,
//             child: Icon(Icons.image),
//           )
//               : Container(
//             height: 300,
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               image: DecorationImage(
//                 image: fl!, // Use the FileImage directly
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30,),
//           ElevatedButton(
//             onPressed: () async {
//               setState(() {
//                 _isScanning = true;
//               });
//
//
//               try {
//                 final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//                 if (xFile != null) {
//                   final imagePath = xFile.path;
//                   _extractedText = await FlutterTesseractOcr.extractText(imagePath);
//                 } else {
//                   // Handle the case when no image is selected.
//                 }
//               } catch (e) {
//                 _extractedText = "Error: ${e.toString()}"; // Display the error message
//               }
//
//
//
//
//               setState(() {
//                 _isScanning = false;
//               });
//             },
//             child: Text("Extract Text"),
//           ),
//           if (_isScanning)
//             const Center(child: CircularProgressIndicator()),
//           if (!_isScanning && _extractedText.isNotEmpty)
//             Text(_extractedText),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
//
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);
//
//
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _ocrText = '';
//   String _ocrHocr = '';
//   Map<String, String> tessimgs = {
//     "en": "https://tesseract.projectnaptha.com/img/eng_bw.png",
//
//   };
//   var LangList = [ "eng"];
//   var selectList = ["eng", ];
//   String path = "";
//   bool bload = false;
//
//   bool bDownloadtessFile = false;
//   // "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FqCviW%2FbtqGWTUaYLo%2FwD3ZE6r3ARZqi4MkUbcGm0%2Fimg.png";
//   var urlEditController = TextEditingController()..text = "https://tesseract.projectnaptha.com/img/eng_bw.png";
//
//   Future<void> writeToFile(ByteData data, String path) {
//     final buffer = data.buffer;
//     return new File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//   }
//
//   void runFilePiker() async {
//     // android && ios only
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       _ocr(pickedFile.path);
//     }
//   }
//
//   void _ocr(url) async {
//     if (selectList.length <= 0) {
//       print("Please select language");
//       return;
//     }
//     path = url;
//     if (kIsWeb == false && (url.indexOf("http://") == 0 || url.indexOf("https://") == 0)) {
//       Directory tempDir = await getTemporaryDirectory();
//       HttpClient httpClient = new HttpClient();
//       HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
//       HttpClientResponse response = await request.close();
//       Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//       String dir = tempDir.path;
//       print('$dir/test.jpg');
//       File file = new File('$dir/test.jpg');
//       await file.writeAsBytes(bytes);
//       url = file.path;
//     }
//     var langs = selectList.join("+");
//
//     bload = true;
//     setState(() {});
//
//     _ocrText = await FlutterTesseractOcr.extractText(url, language: langs, args: {
//       "preserve_interword_spaces": "1",
//     });
//     //  ========== Test performance  ==========
//     // DateTime before1 = DateTime.now();
//     // print('init : start');
//     // for (var i = 0; i < 10; i++) {
//     //   _ocrText =
//     //       await FlutterTesseractOcr.extractText(url, language: langs, args: {
//     //     "preserve_interword_spaces": "1",
//     //   });
//     // }
//     // DateTime after1 = DateTime.now();
//     // print('init : ${after1.difference(before1).inMilliseconds}');
//     //  ========== Test performance  ==========
//
//     // _ocrHocr =
//     //     await FlutterTesseractOcr.extractHocr(url, language: langs, args: {
//     //   "preserve_interword_spaces": "1",
//     // });
//     // print(_ocrText);
//     // print(_ocrText);
//
//     // === web console test code ===
//     // var worker = Tesseract.createWorker();
//     // await worker.load();
//     // await worker.loadLanguage("eng");
//     // await worker.initialize("eng");
//     // // await worker.setParameters({ "tessjs_create_hocr": "1"});
//     // var rtn = worker.recognize("https://tesseract.projectnaptha.com/img/eng_bw.png");
//     // console.log(rtn.data);
//     // await worker.terminate();
//     // === web console test code ===
//
//     bload = false;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("dectt"),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       child: ElevatedButton(
//                           onPressed: () {
//                             showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return SimpleDialog(
//                                     title: const Text('Select Url'),
//                                     children: tessimgs
//                                         .map((key, value) {
//                                       return MapEntry(
//                                           key,
//                                           SimpleDialogOption(
//                                               onPressed: () {
//                                                 urlEditController.text = value;
//                                                 setState(() {});
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Row(
//                                                 children: [
//                                                   Text(key),
//                                                   Text(" : "),
//                                                   Flexible(child: Text(value)),
//                                                 ],
//                                               )));
//                                     })
//                                         .values
//                                         .toList(),
//                                   );
//                                 });
//                           },
//                           child: Text("urls")),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'input image url',
//                         ),
//                         controller: urlEditController,
//                       ),
//                     ),
//                     ElevatedButton(
//                         onPressed: () {
//                           _ocr(urlEditController.text);
//                         },
//                         child: Text("Run")),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     ...LangList.map((e) {
//                       return Row(children: [
//                         Checkbox(
//                             value: selectList.indexOf(e) >= 0,
//                             onChanged: (v) async {
//                               // dynamic add Tessdata
//                               if (kIsWeb == false) {
//                                 Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
//                                 if (!dir.existsSync()) {
//                                   dir.create();
//                                 }
//                                 bool isInstalled = false;
//                                 dir.listSync().forEach((element) {
//                                   String name = element.path.split('/').last;
//                                   // if (name == 'deu.traineddata') {
//                                   //   element.delete();
//                                   // }
//                                   isInstalled |= name == '$e.traineddata';
//                                 });
//                                 if (!isInstalled) {
//                                   bDownloadtessFile = true;
//                                   setState(() {});
//                                   HttpClient httpClient = new HttpClient();
//                                   HttpClientRequest request =
//                                   await httpClient.getUrl(Uri.parse('https://github.com/tesseract-ocr/tessdata/raw/main/${e}.traineddata'));
//                                   HttpClientResponse response = await request.close();
//                                   Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//                                   String dir = await FlutterTesseractOcr.getTessdataPath();
//                                   print('$dir/${e}.traineddata');
//                                   File file = new File('$dir/${e}.traineddata');
//                                   await file.writeAsBytes(bytes);
//                                   bDownloadtessFile = false;
//                                   setState(() {});
//                                 }
//                                 print(isInstalled);
//                               }
//                               if (selectList.indexOf(e) < 0) {
//                                 selectList.add(e);
//                               } else {
//                                 selectList.remove(e);
//                               }
//                               setState(() {});
//                             }),
//                         Text(e)
//                       ]);
//                     }).toList(),
//                   ],
//                 ),
//                 Expanded(
//                     child: ListView(
//                       children: [
//                         path.length <= 0
//                             ? Container()
//                             : path.indexOf("http") >= 0
//                             ? Image.network(path)
//                             : Image.file(File(path)),
//                         bload
//                             ? Column(children: [CircularProgressIndicator()])
//                             :Text(_ocrText)
//                       ],
//                     ))
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.black26,
//             child: bDownloadtessFile
//                 ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [CircularProgressIndicator(), Text('download Trained language files')],
//                 ))
//                 : SizedBox(),
//           )
//         ],
//       ),
//
//       floatingActionButton: kIsWeb
//           ? Container()
//           : FloatingActionButton(
//         onPressed: () {
//           runFilePiker();
//           // _ocr("");
//         },
//         tooltip: 'OCR',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

//
// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _ocrText = '';
//   String _ocrHocr = '';
//   Map<String, String> tessimgs = {
//     "en": "https://tesseract.projectnaptha.com/img/eng_bw.png",
//   };
//   var LangList = ["eng"];
//   var selectList = ["eng"];
//   String path = "";
//   bool bload = false;
//
//   bool bDownloadtessFile = false;
//   var urlEditController =
//   TextEditingController()..text = "https://tesseract.projectnaptha.com/img/eng_bw.png";
//
//   Future<void> writeToFile(ByteData data, String path) {
//     final buffer = data.buffer;
//     return File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//   }
//
//   void runFilePicker() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       _ocr(pickedFile.path);
//     }
//   }
//
//   void _ocr(url) async {
//     if (selectList.isEmpty) {
//       print("Please select a language");
//       return;
//     }
//
//     path = url;
//
//     if (!kIsWeb && (url.startsWith("http://") || url.startsWith("https://"))) {
//       Directory tempDir = await getTemporaryDirectory();
//       HttpClient httpClient = HttpClient();
//       HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
//       HttpClientResponse response = await request.close();
//       Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//       String dir = tempDir.path;
//       print('$dir/test.jpg');
//       File file = File('$dir/test.jpg');
//       await file.writeAsBytes(bytes);
//       url = file.path;
//     }
//
//     var langs = selectList.join("+");
//
//     setState(() {
//       bload = true;
//     });
//
//     _ocrText = await FlutterTesseractOcr.extractText(url, language: langs, args: {"preserve_interword_spaces": "1"});
//
//     setState(() {
//       bload = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("OCR App"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return SimpleDialog(
//                       title: const Text('Select URL'),
//                       children: tessimgs.map((key, value) {
//                         return MapEntry(
//                           key,
//                           SimpleDialogOption(
//                             onPressed: () {
//                               urlEditController.text = value;
//                               Navigator.pop(context);
//                             },
//                             child: Row(
//                               children: [
//                                 Text(key),
//                                 SizedBox(width: 8),
//                                 Flexible(child: Text(value)),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).values.toList(),
//                     );
//                   },
//                 );
//               },
//               child: Text("Choose URL"),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter Image URL',
//               ),
//               controller: urlEditController,
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     _ocr(urlEditController.text);
//                   },
//                   child: Text("Run OCR"),
//                 ),
//                 FloatingActionButton(
//                   onPressed: runFilePicker,
//                   tooltip: 'Select Image',
//                   child: Icon(Icons.add),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 ...LangList.map((e) => Row(
//                   children: [
//                     Checkbox(
//                       value: selectList.contains(e),
//                       onChanged: (v) async {
//                         if (!kIsWeb) {
//                           Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
//                           if (!dir.existsSync()) {
//                             dir.create();
//                           }
//
//                           bool isInstalled = dir.listSync().any((element) => element.path.endsWith('$e.traineddata'));
//
//                           if (!isInstalled) {
//                             setState(() {
//                               bDownloadtessFile = true;
//                             });
//
//                             HttpClient httpClient = HttpClient();
//                             HttpClientRequest request =
//                             await httpClient.getUrl(Uri.parse('https://github.com/tesseract-ocr/tessdata/raw/main/${e}.traineddata'));
//                             HttpClientResponse response = await request.close();
//                             Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//                             String dir = await FlutterTesseractOcr.getTessdataPath();
//                             print('$dir/${e}.traineddata');
//                             File file = File('$dir/${e}.traineddata');
//                             await file.writeAsBytes(bytes);
//
//                             setState(() {
//                               bDownloadtessFile = false;
//                             });
//                           }
//                         }
//
//                         setState(() {
//                           if (selectList.contains(e)) {
//                             selectList.remove(e);
//                           } else {
//                             selectList.add(e);
//                           }
//                         });
//                       },
//                     ),
//                     Text(e),
//                   ],
//                 )),
//               ],
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   if (path.isNotEmpty)
//                     path.startsWith("http")
//                         ? Image.network(path)
//                         : Image.file(File(path)),
//                   if (bload) CircularProgressIndicator(),
//                   Text(_ocrText),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: kIsWeb
//           ? Container()
//           : FloatingActionButton(
//         onPressed: runFilePicker,
//         tooltip: 'Select Image',
//         child: Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
//
//
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _ocrText = '';
  String _ocrHocr = '';
  Map<String, String> tessimgs = {
    "en": "https://tesseract.projectnaptha.com/img/eng_bw.png",
  };
  var LangList = ["eng"];
  var selectList = ["eng"];
  String path = "";
  bool bload = false;
  bool bDownloadtessFile = false;
  var urlEditController =
  TextEditingController()..text = "https://tesseract.projectnaptha.com/img/eng_bw.png";
  FlutterTts flutterTts = FlutterTts();

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> _speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(_ocrText);
  }

  void runFilePicker() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _ocr(pickedFile.path);
    }
  }

  void _ocr(url) async {
    if (selectList.isEmpty) {
      print("Please select a language");
      return;
    }

    path = url;

    if (!kIsWeb && (url.startsWith("http://") || url.startsWith("https://"))) {
      Directory tempDir = await getTemporaryDirectory();
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      String dir = tempDir.path;
      print('$dir/test.jpg');
      File file = File('$dir/test.jpg');
      await file.writeAsBytes(bytes);
      url = file.path;
    }

    var langs = selectList.join("+");

    setState(() {
      bload = true;
    });

    _ocrText = await FlutterTesseractOcr.extractText(url, language: langs, args: {"preserve_interword_spaces": "1"});

    setState(() {
      bload = false;
    });

    // Speak the extracted text
    _speak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OCR App"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Select URL'),
                      children: tessimgs.map((key, value) {
                        return MapEntry(
                          key,
                          SimpleDialogOption(
                            onPressed: () {
                              urlEditController.text = value;
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Text(key),
                                SizedBox(width: 8),
                                Flexible(child: Text(value)),
                              ],
                            ),
                          ),
                        );
                      }).values.toList(),
                    );
                  },
                );
              },
              child: Text("Choose URL"),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Image URL',
              ),
              controller: urlEditController,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _ocr(urlEditController.text);
                  },
                  child: Text("Run OCR"),
                ),
                FloatingActionButton(
                  onPressed: runFilePicker,
                  tooltip: 'Select Image',
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                ...LangList.map((e) => Row(
                  children: [
                    Checkbox(
                      value: selectList.contains(e),
                      onChanged: (v) async {
                        if (!kIsWeb) {
                          Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
                          if (!dir.existsSync()) {
                            dir.create();
                          }

                          bool isInstalled = dir.listSync().any((element) => element.path.endsWith('$e.traineddata'));

                          if (!isInstalled) {
                            setState(() {
                              bDownloadtessFile = true;
                            });

                            HttpClient httpClient = HttpClient();
                            HttpClientRequest request =
                            await httpClient.getUrl(Uri.parse('https://github.com/tesseract-ocr/tessdata/raw/main/${e}.traineddata'));
                            HttpClientResponse response = await request.close();
                            Uint8List bytes = await consolidateHttpClientResponseBytes(response);
                            String dir = await FlutterTesseractOcr.getTessdataPath();
                            print('$dir/${e}.traineddata');
                            File file = File('$dir/${e}.traineddata');
                            await file.writeAsBytes(bytes);

                            setState(() {
                              bDownloadtessFile = false;
                            });
                          }
                        }

                        setState(() {
                          if (selectList.contains(e)) {
                            selectList.remove(e);
                          } else {
                            selectList.add(e);
                          }
                        });
                      },
                    ),
                    Text(e),
                  ],
                )),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  if (path.isNotEmpty)
                    path.startsWith("http")
                        ? Image.network(path)
                        : Image.file(File(path)),
                  if (bload) CircularProgressIndicator(),
                  Text(_ocrText),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: kIsWeb
          ? Container()
          : FloatingActionButton(
        onPressed: runFilePicker,
        tooltip: 'Select Image',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



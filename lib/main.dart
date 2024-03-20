import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tesarcat/Homescreen.dart';
import 'package:tesarcat/detact2.dart';
import 'package:tesarcat/ocrx.dart';
import 'package:tesarcat/summarizer.dart';
import 'detection.dart';
import 'ccx.dart';
import 'dx.dart';



List<CameraDescription>?cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyGridPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyGridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR and Detection Options'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          OptionCard(
            title: 'OCR',
            icon: Icons.image,
            gradientColors: [Color(0xFF6D8AED), Color(0xFFABE0FE)],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Sumz()
                ),
              );
            },
          ),
          OptionCard(
            title: 'Detection',
            icon: Icons.camera_alt,
            gradientColors: [Color(0xFF69F0AE), Color(0xFF00E676)],
            onTap: () {
              print("hello");
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => Dx()//Homex()
                ),
              );
            },
          ),
          OptionCard(
            title: 'Help',
            icon: Icons.help,
            gradientColors: [Color(0xFFF48D7A), Color(0xFFDE6262)],
            onTap: () {
              print('Help option selected');
            },
          ),
          OptionCard(
            title: 'Navigation',
            icon: Icons.navigation,
            gradientColors: [Color(0xFFFA709A), Color(0xFFFECB6E)],
            onTap: () {
              // print("hello");
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>Sumz()
                ),
              );
            },
          ),






        ],
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final Function onTap;

  OptionCard({required this.title, required this.icon, required this.gradientColors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0.0, 2.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 60.0,
                color: Colors.white,
              ),
              SizedBox(height: 10.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontFamily: 'Montserrat', // You can add a custom font
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

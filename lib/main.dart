import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String _yazi = 'QR Okuyucu';
  Future linkeGit() async {
    if (await canLaunch(_yazi)) {
      await launch(_yazi);
    } else {
      setState(() {
        _yazi = 'Gerçek bi link okutur musun lütfen !';
      });
    }
  }

  Future qrOku() async {
    try {
      String _qrCevap = await BarcodeScanner.scan();
      _yazi = _qrCevap;
    } on PlatformException catch (ex) {
      _yazi = ex.code == BarcodeScanner.CameraAccessDenied
          ? 'Kamera izni verilmedi !'
          : 'Bi hata oluştu kb :(';
    } on FormatException {
      _yazi = 'Okuyamadan çıktın biraz daha bekleyebilir misin ?';
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Okuyucu',
          style: GoogleFonts.ranchers(),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '$_yazi',
                style: GoogleFonts.ranchers(
                  textStyle: TextStyle(fontSize: 25, letterSpacing: 2.5),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton.extended(
                icon: Icon(Icons.camera_alt_outlined),
                label: Text(
                  'QR Oku',
                  style: GoogleFonts.ranchers(),
                ),
                onPressed: qrOku,
              ),
              FloatingActionButton.extended(
                icon: Icon(Icons.search),
                label: Text(
                  'Linke Git',
                  style: GoogleFonts.ranchers(),
                ),
                onPressed: linkeGit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

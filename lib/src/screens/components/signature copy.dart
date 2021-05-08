import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

class SignatureScreen extends StatefulWidget {
  SignatureScreen({Key key}) : super(key: key);

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 0.0,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

class _SignatureScreenState extends State<SignatureScreen> {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 2.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              // width: 150.0,
              // height: 50.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: color,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                    debugPrint('${sign.points.length} points in the signature');
                  },
                  backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                  strokeWidth: strokeWidth,
                ),
              ),
              color: Colors.black12,
            ),
          ),
          _img.buffer.lengthInBytes == 0
              ? Container()
              : LimitedBox(
                  maxHeight: 150.0,
                  child: Image.memory(_img.buffer.asUint8List())),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                      color: Colors.blueAccent,
                      onPressed: () async {
                        final sign = _sign.currentState;
                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        final image = await sign.getData();

                        var data = await image.toByteData(
                            format: ui.ImageByteFormat.png);
                        // _save(data);
                        sign.clear();
                        final encoded =
                            base64.encode(data.buffer.asUint8List());
                        setState(() {
                          _img = data;
                        });
                        debugPrint("onPressed " + encoded);
                      },
                      child:
                          Text("Save", style: TextStyle(color: Colors.white))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          final sign = _sign.currentState;
                          sign.clear();
                          setState(() {
                            _img = ByteData(0);
                          });
                          debugPrint("cleared");
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          color = color == Colors.black
                              ? Colors.blue
                              : Colors.black;
                        });
                        debugPrint("change color");
                      },
                      child: Text("Change color",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0))),
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          int min = 1;
                          int max = 10;
                          int selection = min + (Random().nextInt(max - min));
                          strokeWidth = selection.roundToDouble();
                          debugPrint("change stroke width to $selection");
                        });
                      },
                      child: Text("stroke width",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0))),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // _save(ByteData imgData) async {
  //   if(await _requestPermission(Permission))
  //   final result = await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(imgData.buffer.asUint8List()),
  //       quality: 60,
  //       name: "hello");
  //   print(result);
  // }
}

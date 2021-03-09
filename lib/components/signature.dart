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
  var strokeWidth = 1.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            // width: 100.0,
            height: 80.0,
              child: Expanded(
                child: Container(
                  // width: 80.0,
                  // height: 100.0,
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
                  color: Colors.black12,
                ),
              ),
          ),
              
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                            color: Colors.redAccent,
                            onPressed: () {
                              final sign = _sign.currentState;
                              sign.clear();
                              setState(() {
                                _img = ByteData(0);
                              });
                              debugPrint("cleared Signature");
                            },
                            child: Text(
                              "Clear Signature",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                  ),
          
        ],
      )
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

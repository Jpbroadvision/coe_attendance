import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  WatermarkPaint({@required this.price, @required this.watermark});

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 0.0,
        Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}

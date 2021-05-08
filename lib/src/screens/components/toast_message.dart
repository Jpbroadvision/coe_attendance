import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

toastMessage(BuildContext context, String message, [Color color]) {
  showFlash(
    context: context,
    duration: Duration(seconds: 2),
    builder: (context, controller) {
      return Flash(
        backgroundColor: color ?? Colors.green,
        controller: controller,
        style: FlashStyle.floating,
        boxShadows: kElevationToShadow[4],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        child: FlashBar(
          message: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    },
  );
}

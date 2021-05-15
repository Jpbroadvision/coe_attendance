import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

showCustomDialog(
    {BuildContext context, String title, Widget body, Widget action}) {
  showFlash(
    context: context,
    builder: (context, controller) {
      return Flash.dialog(
        controller: controller,
        boxShadows: kElevationToShadow[4],
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: FlashBar(
          title: Text(title, style: TextStyle(fontSize: 20)),
          message: body,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.dismiss();
              },
              child: Text(
                'Cancel',
              ),
            ),
            action ?? SizedBox()
          ],
        ),
      );
    },
  );
}

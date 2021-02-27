import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: Text(
              'Developed by JPbroadvision',
              textAlign: TextAlign.center,
            ),
        ),
      ],
    );
  }
}

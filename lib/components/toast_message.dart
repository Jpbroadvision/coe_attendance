import 'package:flutter/material.dart';

toastMessage(BuildContext context, String message, [Color color]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color == null ? Colors.green : color,
      content: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}

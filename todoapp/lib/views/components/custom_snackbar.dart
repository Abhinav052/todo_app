import 'package:flutter/material.dart';

snackBarCustom(BuildContext context, String msg) {
  if (msg.length > 50) {
    msg = "Something went wrong";
  }
  ScaffoldMessenger.of(context).clearSnackBars();
  final snackBar = SnackBar(
    margin: EdgeInsets.all(16),
    behavior: SnackBarBehavior.floating,
    content: Text(
      msg,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Color(0xffFC5D5D),
    action: SnackBarAction(
      label: 'Dismiss',
      textColor: Colors.white,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

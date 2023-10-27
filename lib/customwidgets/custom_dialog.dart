import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String message;

  CustomDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Mensaje"),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo cuando se presiona el botón
          },
          child: Text("Aceptar"),
        ),
      ],
    );
  }
}

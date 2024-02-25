import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

Future<dynamic> alertResponse(bool res, String message, String title, context, String errorMessage, String errorTitle) {
  if (res) {
    Navigator.pop(context);
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: message,
      confirmBtnText: "Aceptar",
      title: title,
    );
  } else {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: errorMessage,
      confirmBtnText: "Aceptar",
      title: title,
    );
  }
}

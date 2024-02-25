import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Future<void> onSelectNotification(String? payload) async {
//   // Obtén la ruta del archivo PDF (puedes cambiar esto según tu implementación)
//   String pdfPath = "/ruta/del/archivo.pdf";

//   // Abre el archivo PDF con la aplicación predeterminada
//   OpenFile.open(pdfPath);
// }

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndoid =
      AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndoid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (details) async {

    },
  );
}

Future<void> showNotificatios(String tittle, String body, String? url) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails("channelId", "channelName",
          importance: Importance.max, priority: Priority.high);

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  await flutterLocalNotificationsPlugin
      .show(1, tittle, body, notificationDetails, payload: url);
}

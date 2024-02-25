import 'package:flutter/material.dart';
import 'package:flutter_application_2/repository/notifi_service.dart';
import 'login_screen.dart';

// Importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

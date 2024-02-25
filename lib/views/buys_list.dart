import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/customwidgets/custom_drawer.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';
import 'package:flutter_application_2/repository/notifi_service.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class BuysListScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  BuysListScreen({required this.user});

  @override
  _BuysListScreenState createState() => _BuysListScreenState();
}

class _BuysListScreenState extends State<BuysListScreen> {
  List<Map<String, dynamic>?> products1 = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> onSelectNotification(String? payload) async {
    // Maneja la acción después de hacer clic en la notificación
    // Puedes personalizar esta función según tus necesidades
  }

  void showNotifications(String title, String body, String? url) async {
    showNotificatios(title, body, url!);
  }

  Future<List<Map<String, dynamic>?>> getProductsByUser() async {
    products1 = await getBuysList(widget.user['user']);
    return products1;
  }

  void downloadPdf(String url, String date) async {
    dio.Dio dioClient = dio.Dio();

    try {
      // Realiza la solicitud de descarga
      dio.Response response = await dioClient.get(
        url,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );

      // Obtiene el directorio de descargas del dispositivo
      Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');
      var name = date.replaceAll(' ', '').replaceAll(':', '_');
      String fileName = "factura_$name.pdf";
      File file = File("${downloadsDirectory!.path}/$fileName");

      // Escribe los datos descargados en el archivo
      await file.writeAsBytes(response.data);

      // Muestra un mensaje de éxito
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Factura descargada correctamente!",
        confirmBtnText: "Aceptar",
        title: "Descarga",
      );

      // Muestra la notificación
      showNotifications("Descarga completada",
          "El archivo se ha descargado correctamente como $fileName", url);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error de descarga"),
            content: Text("Se produjo un error al descargar el archivo."),
            actions: [
              TextButton(
                child: Text("Cerrar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compras"),
        backgroundColor: Color(0xFF674AEF),
      ),
      drawer: CustomDrawer(user: widget.user),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getProductsByUser(),
              builder: ((context, snapshot) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await getProductsByUser();
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemCount: products1.length,
                    itemBuilder: (context, index) {
                      return createProductCard(products1[index]);
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget createProductCard(Map<String, dynamic>? product) {
    return _cardMainF(product);
  }

  Widget _cardMainF(Map<String, dynamic>? product) {
    return GestureDetector(
      onTap: () {
        // Acción al tocar la tarjeta
      },
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        borderOnForeground: true,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Date: " +
                  (product!['date'] as Timestamp).toDate().toString()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total: " + product['total'].toString()),
                  Text(
                      "Total Cantidad: " + product['totalCantidad'].toString()),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.download),
                onPressed: () async {
                  downloadPdf(product!['file'],
                      (product!['date'] as Timestamp).toDate().toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

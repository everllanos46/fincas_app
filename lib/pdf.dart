import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String> generatePDF(List<Map<String, dynamic>?> products) async {
  final directory = await getApplicationDocumentsDirectory();
  final pdf = pw.Document();
  final pw.Font ttfRoboto =
      pw.Font.ttf(await rootBundle.load("./fonts/Roboto-Italic.ttf"));
  final pw.Font ttfRobotoBold =
      pw.Font.ttf(await rootBundle.load("./fonts/Roboto-Black.ttf"));

  // Agregar una página al documento
  pdf.addPage(pw.Page(
    build: (pw.Context context) {
      // Agregar el título y la fecha
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Puedes ajustar el tamaño de la imagen según tus necesidades
          pw.Text('Fincas App Factura', style: pw.TextStyle(fontSize: 20)),
          pw.Text('Fecha: ${DateTime.now().toLocal()}'),
          pw.SizedBox(height: 10),
          // Agregar la lista de productos
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              // Encabezados de la tabla
              pw.TableRow(
                children: [
                  pw.Text('Producto',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('Precio',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              // Contenido de la tabla
              for (var product in products)
                pw.TableRow(
                  children: [
                    pw.Text(product!['name'].toString()),
                    pw.Text(product!['price'].toString()),
                  ],
                ),
              // Agregar la fila de total
              pw.TableRow(
                children: [
                  pw.Text('Total',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  // Calcular el total sumando los precios de todos los productos
                  pw.Text(
                    products
                        .map((product) =>
                            double.parse(product!['price'].toString()))
                        .reduce((a, b) => a + b)
                        .toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    },
  ));

  var url = "";
  final file = File('${directory.path}/factura.pdf');
  await file.writeAsBytes(await pdf.save());
  url = await uploadDocuments(file);
  return url;
}

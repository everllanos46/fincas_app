import 'package:flutter/material.dart';
import 'package:flutter_application_2/cart/product_card.dart';
import 'package:flutter_application_2/customwidgets/custom_drawer.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/pdf.dart';
import 'package:flutter_application_2/product/add.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';
import 'package:flutter_application_2/utils/alert.dart';
import 'package:quickalert/quickalert.dart';

class CartViewScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  CartViewScreen({required this.user});
  @override
  _CartViewScreenState createState() => _CartViewScreenState();
}

class _CartViewScreenState extends State<CartViewScreen> {
  List<Map<String, dynamic>?> products1 = [];
  Future<List<Map<String, dynamic>?>> getProductsByUser() async {
    products1 = await geProductsCartByField(widget.user['user']);
    return products1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Carrito"),
          backgroundColor: Color(0xFF674AEF),
        ),
        drawer: CustomDrawer(user: widget.user),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getProductsByUser(),
                  builder: ((context, snapshot) {
                    if (products1.isEmpty) {
                      return Center(
                        child: Text("Su carrito de compras está vacío."),
                      );
                    } else {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await getProductsByUser();
                          setState(() {});
                        },
                        child: ListView.builder(
                          itemCount: products1.length,
                          itemBuilder: (context, index) {
                            return createProductCard(products1[index], true);
                          },
                        ),
                      );
                    }
                  })),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showConfirmationDialog(context);
          },
          child: Icon(Icons.shopping_cart),
          backgroundColor: Color(0xFF674AEF),
          tooltip: "Hola",
        ));
  }

  Widget createProductCard(Map<String, dynamic>? product, bool type) {
    return ProductCard(product, type, widget.user);
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    var res = false;
    return QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: "¿Está seguro de realizar la compra?",
        confirmBtnText: "Aceptar",
        title: "Confirmar Compra",
        onConfirmBtnTap: () async {
          var pdfUrl = await generatePDF(products1);
          res = await buyCart(products1, widget.user, pdfUrl);
          Navigator.pop(context);
          await alertResponse(
              res,
              "Carrito comprado correctamente!",
              "Comprado!",
              context,
              "Hubo un error al momento de comprar los productos del carrito",
              "Error!");
        },
        onCancelBtnTap: () {
          Navigator.of(context).pop();
        });
  }
}

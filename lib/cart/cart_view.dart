import 'package:flutter/material.dart';
import 'package:flutter_application_2/customwidgets/custom_drawer.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/product/add.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';

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
        ));
  }

  Widget createProductCard(Map<String, dynamic>? product, bool type) {
    return _cardMainF(product, type);
  }

  Widget _cardMainF(Map<String, dynamic>? product, bool type) {
    TextEditingController nombreController =
        TextEditingController(text: product!['name']);
    TextEditingController pesoController =
        TextEditingController(text: product!['weight']);
    TextEditingController precioController =
        TextEditingController(text: product!['price']);
    TextEditingController disponibilidadController =
        TextEditingController(text: product!['availability'].toString());

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductRegistrationScreen(
                    user: widget.user,
                    product: product,
                  )),
        );
      },
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        borderOnForeground: true,
        child: Column(
          children: <Widget>[
            Image.network(product!['image'],
                height: 150), // Ajusta el tamaño de la imagen
            ListTile(
              title: Text("Nombre: " + product['name']),
              subtitle: Text(product!['description']),
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "+",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF674AEF),
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 5,
                            )),
                      ),
                      SizedBox(
                          width: 90), // Espacio entre el botón "-" y el número
                      Text(
                        product!['availability'].toString(),
                        style: TextStyle(
                          fontSize: 24, // Ajusta el tamaño del número
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 133),
                      Container(
                        child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF674AEF),
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 5,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar el diálogo de confirmación
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Compra"),
          content: Text("¿Está seguro de realizar la compra?"),
          actions: [
            TextButton(
              onPressed: () {
                // Lógica para cancelar la compra
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await buyCart(products1);
                Navigator.pop(context);
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}

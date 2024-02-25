import 'package:flutter/material.dart';
import 'package:flutter_application_2/customwidgets/custom_drawer.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/product/add.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';

class InventoryViewScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  InventoryViewScreen({required this.user});
  @override
  _InventoryViewScreenState createState() => _InventoryViewScreenState();
}

class _InventoryViewScreenState extends State<InventoryViewScreen> {
  List<Map<String, dynamic>?> products1 = [];
  Future<List<Map<String, dynamic>?>> getProductsByUser() async {
    products1 = await geProductsByField(widget.user['user']);
    return products1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inventario"),
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
                        itemCount: products1.length, // Utiliza productList.
                        itemBuilder: (context, index) {
                          return createProductCard(products1[index], true);
                        },
                      ),
                    );
                  })),
            ),
          ],
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
            ),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        borderOnForeground: true,
        child: Column(
          children: <Widget>[
            Image.network(product!['image'], height: 150),
            ListTile(
              title: Text("Nombre: " + product['name']),
              subtitle: Text(product!['description']),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Muestra el diálogo de confirmación
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Eliminar producto"),
                        content:
                            Text("¿Seguro que desea eliminar el producto?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancelar"),
                            onPressed: () {
                              // Cierra el diálogo si se presiona cancelar
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Aceptar"),
                            onPressed: () async {
                              await deleteProduct(id: product!['id']);
                              await getProductsByUser();
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> createProductCards(List<ProductData> productList) {
    return productList.map((product) {
      return _cardMain(product);
    }).toList();
  }

  Widget _cardMain(ProductData product) {
    TextEditingController nombreController =
        TextEditingController(text: product.name);
    TextEditingController pesoController =
        TextEditingController(text: product.weight);
    TextEditingController precioController =
        TextEditingController(text: product.price);
    TextEditingController disponibilidadController =
        TextEditingController(text: product.availability.toString());

    return GestureDetector(
      onTap: () {
        if (!product.type) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => ProductRegistrationScreen(
          //             user: widget.user,
          //             product: product,
          //           )),
          // );
        }
      },
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        borderOnForeground: true,
        child: Column(
          children: <Widget>[
            Image.network(product.image,
                height: 150), // Ajusta el tamaño de la imagen
            ListTile(
              title: Text("Nombre: " + product.name),
              subtitle: Text(product.description),
            ),
          ],
        ),
      ),
    );
  }
}

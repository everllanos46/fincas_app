import 'package:flutter/material.dart';
import 'package:flutter_application_2/cart/cart_view.dart';
import 'package:flutter_application_2/product/view.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';
import 'customwidgets/custom_drawer.dart';
import 'product/add.dart';
import "package:flutter_application_2/data/product.dart";

const kBackgroundColor = Color(0xFFF1EFF1);
const kPrimaryColor = Colors.amber;
const kSecondaryColor = Color(0xFFFFA41B);
const kTextColor = Color(0xFF000839);
const kTextLightColor = Color(0xFF747474);
const kBlueColor = Color(0xFF40bad5);
const kDefaultPadding = 20.0;

class MainProductsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  MainProductsScreen({required this.user});

  @override
  _MainProductsScreenState createState() => _MainProductsScreenState();
}

class _MainProductsScreenState extends State<MainProductsScreen> {
  String _searchValue = "";
  List<Map<String, dynamic>?> products1 = [];
  List<Map<String, dynamic>?> products2 = [];
  bool _showAdditionalButtons = false;

  Future<List<Map<String, dynamic>?>> getProductsByUser() async {
    products1 = await geProductsByField(widget.user['user']);
    return products1;
  }

  Future<List<Map<String, dynamic>?>> getProducts() async {
    products2 = await geProducts();
    return products2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menú"),
        backgroundColor: Color(0xFF674AEF),
        centerTitle: false,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => MainProductsScreen(
                    user: widget.user,
                  ),
                ),
                (route) => false,
              );
            },
            icon: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://bloglatam.jacto.com/wp-content/uploads/2022/07/tipos-de-ganaderia.jpeg"),
                ),
              ),
            ),
          ),
        ],
      ),
      body: widget.user["role"] == 'admin'
          ? MainProductsBodyWithTabs()
          : NonAdminView(), // Mostrar una vista de ejemplo si el rol no es "admin"
      floatingActionButton: widget.user['role'] == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showAdditionalButtons = !_showAdditionalButtons;
                });
              },
              backgroundColor: Color(0xFF674AEF),
              child: Icon(Icons.add_business),
            )
          : null,
      drawer: CustomDrawer(user: widget.user),
    );
  }

  Widget MainProductsBodyWithTabs() {
    return Stack(
      children: [
        Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 9,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFF674AEF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45),
                ),
              ),
              child: Center(child: SearchBox()),
            ),
            DefaultTabController(
              length: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 120, 40, 10),
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Mis productos'),
                        Tab(text: 'Todos los productos'),
                      ],
                    ),
                    SizedBox(height: 1),
                    Expanded(
                      child: TabBarView(
                        children: [
                          FutureBuilder(
                              future: getProductsByUser(),
                              builder: ((context, snapshot) {
                                return RefreshIndicator(
                                  onRefresh: () async {
                                    // Aquí puedes realizar una nueva petición o cargar los datos nuevamente.
                                    await getProductsByUser(); // Reemplaza fetchData con tu lógica para obtener productos.
                                  },
                                  child: ListView.builder(
                                    itemCount: products1
                                        .length, // Utiliza productList.
                                    itemBuilder: (context, index) {
                                      return createProductCard(
                                          products1[index], true);
                                    },
                                  ),
                                );
                              })),
                          FutureBuilder(
                              future: getProducts(),
                              builder: ((context, snapshot) {
                                return RefreshIndicator(
                                  onRefresh: () async {
                                    // Aquí puedes realizar una nueva petición o cargar los datos nuevamente.
                                    await getProducts(); // Reemplaza fetchData con tu lógica para obtener productos.
                                  },
                                  child: ListView.builder(
                                    itemCount: products2
                                        .length, // Utiliza productList.
                                    itemBuilder: (context, index) {
                                      return createProductCard(
                                          products2[index], false);
                                    },
                                  ),
                                );
                              })),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showAdditionalButtons) ...[
              Positioned(
                top: 650,
                right: 12,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductRegistrationScreen(
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF674AEF),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
              Positioned(
                top: 610,
                right: 12,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartViewScreen(
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF674AEF),
                    shape: CircleBorder(),
                  ),
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ],
    );
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
        if (!type) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProductViewScreen(product: product, user: widget.user)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductRegistrationScreen(
                      user: widget.user,
                      product: product,
                    )),
          );
        }
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
          ],
        ),
      ),
    );
  }

  // Widget _cardMain(ProductData product) {
  //   TextEditingController nombreController =
  //       TextEditingController(text: product.name);
  //   TextEditingController pesoController =
  //       TextEditingController(text: product.weight);
  //   TextEditingController precioController =
  //       TextEditingController(text: product.price);
  //   TextEditingController disponibilidadController =
  //       TextEditingController(text: product.availability.toString());

  //   return GestureDetector(
  //     onTap: () {
  //       if (product.type) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => ProductViewScreen(
  //                     product: product,
  //                   )),
  //         );
  //       } else {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => ProductRegistrationScreen(
  //                     user: widget.user,
  //                     product: product,
  //                   )),
  //         );
  //       }
  //     },
  //     child: Card(
  //       elevation: 5.0,
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //       borderOnForeground: true,
  //       child: Column(
  //         children: <Widget>[
  //           Image.network(product.image,
  //               height: 150), // Ajusta el tamaño de la imagen
  //           ListTile(
  //             title: Text("Nombre: " + product.name),
  //             subtitle: Text(product.description),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget NonAdminView() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 7,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFF674AEF),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
          child: Center(child: SearchBox()),
        ),
        Expanded(
          child: FutureBuilder(
              future: geProducts(),
              builder: ((context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return createProductCard(snapshot.data![index], false);
                  },
                );
              })),
        ),
      ],
    );
  }

  Widget SearchBox() {
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) {
          _searchValue = value;
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: 'Buscar',
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // List<Widget> createProductCards(List<ProductData> productList) {
  //   return productList.map((product) {
  //     return _cardMain(product);
  //   }).toList();
  // }

  Widget createProductCard(Map<String, dynamic>? product, bool type) {
    return _cardMainF(product, type);
  }

  Widget _buildAddProductDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Añadir Producto",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(labelText: "Nombre"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Descripción"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Peso"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Precio"),
          ),
          TextField(
            decoration: InputDecoration(labelText: "Disponibilidad"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Lógica para agregar el producto
              Navigator.pop(context);
            },
            child: Text("Agregar"),
          ),
        ],
      ),
    );
  }
}

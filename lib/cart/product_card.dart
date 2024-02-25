import 'package:flutter/material.dart';
import 'package:flutter_application_2/product/add.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic>? product;
  final bool type;
  final Map<String, dynamic> user;

  ProductCard(this.product, this.type, this.user);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late TextEditingController nombreController;
  late TextEditingController pesoController;
  late TextEditingController precioController;
  late TextEditingController disponibilidadController;
  late int quantityCart;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.product!['name']);
    pesoController = TextEditingController(text: widget.product!['weight']);
    precioController = TextEditingController(text: widget.product!['price']);
    disponibilidadController =
        TextEditingController(text: widget.product!['availability'].toString());
    quantityCart = widget.product!['availability'].toInt();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductRegistrationScreen(
              user: widget.user,
              product: widget.product,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        borderOnForeground: true,
        child: Column(
          children: <Widget>[
            Image.network(widget.product!['image'], height: 150),
            ListTile(
              title: Text("Nombre: " + widget.product!['name']),
              subtitle: Text(widget.product!['description']),
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
                          onPressed: () {
                            setState(() {
                              int max = widget.product!['max'].toInt();
                              if (quantityCart < max) {
                                quantityCart++;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF674AEF),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      Text(
                        "${quantityCart}",
                        style: TextStyle(
                          fontSize: 24,
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
                          onPressed: () {
                            setState(() {
                              if (quantityCart > 1) {
                                quantityCart--;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF674AEF),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            elevation: 5,
                          ),
                        ),
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
}

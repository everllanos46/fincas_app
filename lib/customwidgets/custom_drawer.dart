import 'package:flutter/material.dart';
import 'package:flutter_application_2/inventory/list.dart';
import 'package:flutter_application_2/product/add.dart';
import 'package:flutter_application_2/main_products_screen.dart';
import 'package:flutter_application_2/login_screen.dart';
import 'package:flutter_application_2/views/buys_list.dart';
import 'package:flutter_application_2/views/settings_view.dart';


class CustomDrawer extends StatelessWidget {
  final Map<String, dynamic> user;
  CustomDrawer({required this.user});
  
  @override
  Widget build(BuildContext context) {
    return user['role'] == "admin" ? Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Color(0xFF674AEF), // Color morado
            child: DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://s3-symbol-logo.tradingview.com/azul--600.png"),
                    radius: 40.0, // Tamaño del avatar
                  ),
                  SizedBox(height: 8),
                  Text(
                    "FincasApps",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Inicio"),
            leading: Icon(Icons.house_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainProductsScreen(
                          user: this.user,
                        )),
              );
            },
          ),
          ListTile(
            title: Text("Agregar Producto"),
            leading: Icon(Icons.add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductRegistrationScreen(user: this.user)),
              );
            },
          ),
          ListTile(
            title: Text("Inventario"),
            leading: Icon(Icons.inventory_2_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InventoryViewScreen(user: this.user)),
              );
            },
          ),
          ListTile(
            title: Text("Lista de compras"),
            leading: Icon(Icons.card_travel),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BuysListScreen(user: this.user)),
              );
            },
          ),
          ListTile(
            title: Text("Ajustes"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AjustesScreen(user: this.user)),
              );
            },
          ),
          ListTile(
            title: Text("Cerrar Sesión"),
            leading: Icon(Icons.close),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()),
              );
            },
          )
          // Agrega más elementos del Drawer según tus necesidades
        ],
      ),
    ) : Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Color(0xFF674AEF), // Color morado
            child: DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://s3-symbol-logo.tradingview.com/azul--600.png"),
                    radius: 40.0, // Tamaño del avatar
                  ),
                  SizedBox(height: 8),
                  Text(
                    "FincasApps",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text("Inicio"),
            leading: Icon(Icons.house_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainProductsScreen(
                          user: this.user,
                        )),
              );
            },
          ),
          ListTile(
            title: Text("Lista de compras"),
            leading: Icon(Icons.card_travel),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BuysListScreen(user: this.user)),
              );
            },
          ),
          ListTile(
            title: Text("Ajustes"),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AjustesScreen(user: this.user)),
              );
            },
          ),
          ListTile(
            title: Text("Cerrar Sesión"),
            leading: Icon(Icons.close),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()),
              );
            },
          )
          // Agrega más elementos del Drawer según tus necesidades
        ],
      ),
    );
  }
}

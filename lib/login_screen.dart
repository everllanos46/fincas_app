import 'dart:ui'; // Agrega esta importación

import 'package:flutter/material.dart';
import 'main_products_screen.dart';
import 'register.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _userController;
  late TextEditingController _passController;

  @override
  void initState() {
    _userController = TextEditingController();
    _passController = TextEditingController();

    super.initState();
  }

  List<Map<String, dynamic>> users = [
    {"user": "finca1", "password": "123", "role": "admin"},
    {"user": "finca2", "password": "123", "role": "cliente"},
    {"user": "finca3", "password": "123", "role": "admin"},
    // Agrega más usuarios si es necesario
  ];

  Future<Map<String, dynamic>?> login(String user, String password) async {
    return await getUserByField(user, password);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://bloglatam.jacto.com/wp-content/uploads/2022/07/tipos-de-ganaderia.jpeg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 5.0,
            sigmaY:
                5.0), // Ajusta el valor de sigma para controlar el nivel de desenfoque
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://s3-symbol-logo.tradingview.com/azul--600.png',
                    width: 80,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Bienvenido!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Por favor ingresa tus datos',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                        child: TextField(
                          controller: _userController,
                          decoration: InputDecoration(
                            suffix: GestureDetector(
                              child: Icon(Icons.close),
                              onTap: () {
                                _userController.clear();
                              },
                            ),
                            hintText: 'Usuario',
                            prefixIcon: Icon(Icons.person),
                            contentPadding: EdgeInsets.all(10),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 18),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                        child: TextField(
                          controller: _passController,
                          decoration: InputDecoration(
                            suffix: GestureDetector(
                              child: Icon(Icons.close),
                              onTap: () {
                                _passController.clear();
                              },
                            ),
                            hintText: 'Contraseña',
                            prefixIcon: Icon(Icons.password),
                            contentPadding: EdgeInsets.all(10),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 18),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      InkWell(
                        onTap: () {
                          signIn(_userController.text, _passController.text);
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Registro',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn(String user, String password) async {
    if (user.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error!'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Tiene uno o dos campos vacíos!'),
                Image(
                  image: NetworkImage(
                    'http://altaglatam.com/wp-content/uploads/2014/03/errores.png',
                  ),
                  height: 50,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(child: Text('Cancelar'), onPressed: () {})
            ],
          );
        },
        barrierDismissible: true,
      );
    } else {
      Map<String, dynamic>? user =
          await login(_userController.text, _passController.text);
      if (user!.isNotEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MainProductsScreen(
                user: user), // Puedes pasar el usuario a la pantalla principal
          ),
          (route) => false,
        );
      }
    } /*else {
      // Muestra un mensaje de error si las credenciales son incorrectas
      _showAlerts(context, false);
    }*/
  }

  void _showAlerts(BuildContext context, bool login) {
    if (login) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Bienvenido'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Usuario y contraseña correcta, bienvenido!'),
                Image(
                  image: NetworkImage(
                    'https://definicion.de/wp-content/uploads/2017/01/Correcto.jpg',
                  ),
                  height: 100,
                ),
              ],
            ),
          );
        },
        barrierDismissible: true,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error!'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Usuario o contraseña incorrecta, vuelva a intentar!'),
                Image(
                  image: NetworkImage(
                    'http://altaglatam.com/wp-content/uploads/2014/03/errores.png',
                  ),
                  height: 50,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(child: Text('Cancelar'), onPressed: () {})
            ],
          );
        },
        barrierDismissible: true,
      );
    }
  }
}

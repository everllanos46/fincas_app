import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white, // Cambia el color de fondo del Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF674AEF), // Cambia el color de fondo del encabezado
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white, // Cambia el color del texto
                  fontSize: 24.0, // Cambia el tamaño del texto
                ),
              ),
            ),
            ListTile(
              title: Text('Principal'),
              leading: Icon(Icons.home),
              onTap: () {
                // Agrega la lógica para la opción "Principal"
              },
            ),
            ListTile(
              title: Text('Configuración'),
              leading: Icon(Icons.settings),
              onTap: () {
                // Agrega la lógica para la opción "Configuración"
              },
            ),
            ListTile(
              title: Text('Cerrar Sesión'),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                // Agrega la lógica para la opción "Cerrar Sesión"
              },
            ),
          ],
        ),
      ),
    );
  }
}

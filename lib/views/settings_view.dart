import 'package:flutter/material.dart';
import 'package:flutter_application_2/sqlite/database.dart';

class AjustesScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  AjustesScreen({required this.user});
  @override
  _AjustesScreenState createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool iniciarSesionConHuella = false;
  bool mantenerSesionIniciada = false;

  @override
  void initState() {
    super.initState();
    _clearPreviousAjustes(); // Limpia la información previamente guardada
    _loadAjustes();
  }

  Future<void> _loadAjustes() async {
    Map<String, dynamic>? ajustes = await DatabaseHelper.instance.getAjustes();
    if (ajustes != null) {
      setState(() {
        iniciarSesionConHuella = ajustes['iniciarSesionConHuella'] == 1;
        mantenerSesionIniciada = ajustes['mantenerSesionIniciada'] == 1;
      });
    }
  }

  Future<void> _clearPreviousAjustes() async {
    // Borra la información previamente guardada
    await DatabaseHelper.instance.clearAjustes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajustes"),
        backgroundColor: Color(0xFF674AEF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.fingerprint), // Icono de huella
              title: Text("Iniciar sesión con huella"),
              subtitle: Text("Permite iniciar sesión con huella dactilar"),
              trailing: Switch(
                value: iniciarSesionConHuella,
                onChanged: (value) async {
                  setState(() {
                    iniciarSesionConHuella = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.person), // Icono de persona
              title: Text("Recordar datos de inicio"),
              subtitle: Text("Recuerda los datos con los que inició sesión."),
              trailing: Switch(
                value: mantenerSesionIniciada,
                onChanged: (value) async {
                  setState(() {
                    mantenerSesionIniciada = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveAjustes();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ajustes guardados exitosamente'),
                  ),
                );
              },
              child: Text('Guardar Ajustes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAjustes() async {
    await DatabaseHelper.instance.saveAjustes(
      iniciarSesionConHuella: iniciarSesionConHuella,
      mantenerSesionIniciada: mantenerSesionIniciada,
      usuario: widget.user['user'],
      password: widget.user['password'],
    );
  }
}

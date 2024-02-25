import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usuarioController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  bool isAdmin = false;
  File? _image;

  @override
  void initState() {
    super.initState();

    usuarioController.text = widget.user['user'];
    emailController.text = widget.user['email'];
    telefonoController.text = widget.user['telefono'];
    contrasenaController.text = widget.user['password'];
    isAdmin = widget.user['role'] == "admin" ? true : false;
    setState(() {});
  }

  void updateUser() async {
    if (_formKey.currentState!.validate()) {
      String role = isAdmin ? "admin" : "user";

      var res = await updateUserCollection(
        email: emailController.text,
        password: contrasenaController.text,
        role: role,
        telefono: telefonoController.text,
        user: usuarioController.text,
        imagen: _image != null ? File(_image!.path) : null,
      );
      
      if (res) {
        Navigator.pop(context);
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Perfil actualizado correctamente',
            confirmBtnText: "Aceptar",
            title: "Todo correcto!");
      } else {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Hubo un error al momento de actualizar los datos,',
            confirmBtnText: "Aceptar",
            title: "Error");
      }

      
    }
  }

  Future getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil"),
        backgroundColor: Color(0xFF674AEF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : widget.user['imagen'] != null
                              ? NetworkImage(widget.user['imagen'])
                              : AssetImage('assets/default_image.png')
                                  as ImageProvider<Object>?,
                      backgroundColor: Colors.transparent,
                    ),
                    ElevatedButton(
                      onPressed: getImageFromGallery,
                      child: Text('Galería'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF674AEF),
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: getImageFromCamera,
                      child: Text('Cámara'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF674AEF),
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: usuarioController,
                  decoration: InputDecoration(
                    labelText: "Usuario",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  enabled: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: contrasenaController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: telefonoController,
                  decoration: InputDecoration(
                    labelText: "Teléfono",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text("¿Es administrador?"),
                    Switch(
                      value: isAdmin,
                      onChanged: (value) {
                        setState(() {
                          isAdmin = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF674AEF),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Actualizar",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

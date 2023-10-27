import 'package:flutter/material.dart';
import 'package:flutter_application_2/customwidgets/custom_drawer.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductRegistrationScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic>? product;

  ProductRegistrationScreen({required this.user, this.product});

  @override
  _ProductRegistrationScreenState createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  XFile? selectedImage;
  TextEditingController cantidadController = TextEditingController();

  @override
  void initState() {
    mapear();
    super.initState();
  }

  void mapear() async {
    if (widget.product != null) {
      nombreController.text = widget.product!['name'];
      descripcionController.text = widget.product!['description'];
      pesoController.text = widget.product!['weight'];
      precioController.text = widget.product!['price'];
      cantidadController.text = widget.product!['availability'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product != null ? "Actualizar producto" : "Registrar Producto",
        ),
        backgroundColor: Color(0xFF674AEF),
      ),
      drawer: CustomDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  widget.product != null
                      ? "Actualizar los detalles del producto"
                      : "Completa los detalles del producto",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombre",
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
                  controller: descripcionController,
                  decoration: InputDecoration(
                    labelText: "Descripción",
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
                  controller: pesoController,
                  decoration: InputDecoration(
                    labelText: "Peso",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: precioController,
                  decoration: InputDecoration(
                    labelText: "Precio",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        selectedImage = image;
                      });
                    }
                  },
                  child: Column(
                    children: [
                      if (selectedImage != null)
                        Image.file(File(selectedImage!.path),
                            width: 150, height: 150),
                      if (selectedImage == null)
                        Icon(Icons.add_a_photo, size: 50),
                      Text(
                        "Seleccionar imagen",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF674AEF),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: cantidadController,
                  decoration: InputDecoration(
                    labelText: "Cantidad",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo es requerido';
                    }
                    if (int.parse(value) <= 0) {
                      return 'El valor debe ser mayor que 0';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                    child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (widget.product != null) {
                        await updateProduct(
                          id: widget.product!['id'],
                          name: nombreController.text,
                          description: descripcionController.text,
                          weight: pesoController.text,
                          price: precioController.text,
                          user: widget.user['user'],
                          imagen: File(selectedImage!.path),
                          cantidad: int.parse(cantidadController.text),
                        );
                      } else {
                        await addProduct(
                          name: nombreController.text,
                          description: descripcionController.text,
                          weight: pesoController.text,
                          price: precioController.text,
                          user: widget.user['user'],
                          imagen: File(selectedImage!.path),
                          cantidad: int.parse(cantidadController.text),
                        );
                      }

                      Navigator.pop(context); // Cierra la vista de registro
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
                      widget.product != null ? "Actualizar" : "Agregar",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

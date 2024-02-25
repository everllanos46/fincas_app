import 'package:flutter/material.dart';
import 'package:flutter_application_2/customwidgets/custom_drawer.dart';
import 'package:flutter_application_2/data/product.dart';
import 'package:flutter_application_2/repository/firebase_service.dart';
import 'package:flutter_application_2/utils/alert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

import 'package:photo_view/photo_view_gallery.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoViewGallery.builder(
                                itemCount: 1,
                                builder: (context, index) {
                                  return PhotoViewGalleryPageOptions(
                                    imageProvider:
                                        NetworkImage(widget.product!['image']),
                                    minScale: PhotoViewComputedScale.contained,
                                    maxScale:
                                        PhotoViewComputedScale.covered * 2,
                                  );
                                },
                                scrollPhysics: BouncingScrollPhysics(),
                                backgroundDecoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                                pageController: PageController(),
                              ),
                            ),
                          );
                        },
                        onTap: () async {
                          final XFile? image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              selectedImage = image;
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: selectedImage != null
                              ? FileImage(File(selectedImage!.path))
                              : widget.product != null
                                  ? NetworkImage(widget.product!['image'])
                                      as ImageProvider<Object>?
                                  : NetworkImage(
                                      'https://png.pngitem.com/pimgs/s/157-1571855_upload-button-transparent-upload-to-cloud-hd-png.png'), // Reemplaza con la URL real
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
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
                      try {
                        double parsedValue = double.parse(value);
                        if (parsedValue <= 0) {
                          return 'El valor debe ser mayor que 0';
                        }
                      } catch (e) {
                        return 'Ingresa un número válido';
                      }
                      return null;
                    }),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.product != null) {
                          var res = await updateProduct(
                            id: widget.product!['id'],
                            name: nombreController.text,
                            description: descripcionController.text,
                            weight: pesoController.text,
                            price: precioController.text,
                            type: 1,
                            user: widget.user['user'],
                            imagen:  File(selectedImage?.path ?? widget.product!['image']),
                            cantidad: cantidadController.text.isNotEmpty
                                ? cantidadController.text.contains('.')
                                    ? int.parse(
                                        cantidadController.text.split('.')[0])
                                    : int.tryParse(cantidadController.text) ?? 0
                                : 0,
                          );
                          await alertResponse(res, "Producto actualizado correctamente!", "Actualizado!", context, "Hubo un error al momento de actualizar el producto", "Error!");
                        } else {
                          var res = await addProduct(
                            name: nombreController.text,
                            description: descripcionController.text,
                            weight: pesoController.text,
                            price: precioController.text,
                            user: widget.user['user'],
                            imagen: File(selectedImage!.path),
                            cantidad: int.parse(cantidadController.text),
                          );
                          await alertResponse(res, "Producto agregado correctamente!", "Agregado!", context, "Hubo un error al momento de agregar el producto", "Error!");
                        }
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getUsers() async {
  List users = [];
  CollectionReference collectionReference = db.collection('users');
  QuerySnapshot queryUsers = await collectionReference.get();

  queryUsers.docs.forEach((element) {
    users.add(element.data());
  });
  return users;
}

Future<Map<String, dynamic>?> getUserByField(
    String username, String password) async {
  CollectionReference collectionReference = db.collection('users');
  QuerySnapshot queryUsers = await collectionReference
      .where('user', isEqualTo: username)
      .where('password', isEqualTo: password)
      .get();
  Map<String, dynamic>? user = {};
  if (queryUsers.docs.isNotEmpty) {
    user = documentSnapshotToMap(queryUsers.docs[0]);
  }
  return user;
}

Map<String, dynamic>? documentSnapshotToMap(QueryDocumentSnapshot document) {
  if (document == null || !document.exists) {
    return null;
  }

  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  return data;
}

Future<List<Map<String, dynamic>?>> geProducts() async {
  CollectionReference collectionReference = db.collection('products');
  QuerySnapshot queryUsers = await collectionReference.get();
  List<Map<String, dynamic>?> user = [];
  if (queryUsers.docs.isNotEmpty) {
    user = documentSnapshotsToList(queryUsers.docs);
  }
  return user;
}

Future<List<Map<String, dynamic>?>> geProductsByField(String username) async {
  CollectionReference collectionReference = db.collection('products');
  QuerySnapshot queryUsers =
      await collectionReference.where('user', isEqualTo: username).get();
  List<Map<String, dynamic>?> user = [];
  if (queryUsers.docs.isNotEmpty) {
    user = documentSnapshotsToList(queryUsers.docs);
  }
  return user;
}

Future<List<Map<String, dynamic>?>> geProductsCartByField(
    String username) async {
  CollectionReference collectionReference = db.collection('cart');
  QuerySnapshot queryUsers =
      await collectionReference.where('user', isEqualTo: username).get();
  List<Map<String, dynamic>?> user = [];
  if (queryUsers.docs.isNotEmpty) {
    user = documentSnapshotsToList(queryUsers.docs);
  }
  return user;
}

List<Map<String, dynamic>?> documentSnapshotsToList(
    List<QueryDocumentSnapshot> documents) {
  List<Map<String, dynamic>?> resultList = [];
  for (var document in documents) {
    Map<String, dynamic>? data = documentSnapshotToMap(document);
    resultList.add(data);
  }
  return resultList;
}

Future<void> addUserToUserCollection(String email, String password, String role,
    String telefono, String user) async {
  CollectionReference collectionReference = db.collection('users');
  await collectionReference.add({
    'email': email,
    'password': password,
    'role': role,
    'telefono': telefono,
    'user': user,
  });
}

Future<void> addProduct({
  required String name,
  required String description,
  required String weight,
  required String price,
  required String user,
  required imagen,
  required int cantidad,
}) async {
  CollectionReference productsCollection = db.collection('products');
  var id = await geProducts();
  var url = await uploadImageToFirebaseStorage(imagen);
  try {
    await productsCollection.add({
      'name': name,
      'description': description,
      'weight': weight,
      'price': price,
      'user': user,
      'image': url,
      'availability': cantidad.toDouble(),
      'id': id.length,
    });
    print('Producto agregado con éxito');
  } catch (e) {
    print('Error al agregar el producto: $e');
  }
}

Future<void> buyCart(List<Map<String, dynamic>?> products) async {
  products.forEach((element) async {
    CollectionReference productsCollection = db.collection('products');
    var id = await geProducts();
    try {
      await productsCollection.add({
        'name': element!['name'],
        'description': element!['description'],
        'weight': element!['weight'],
        'price': element!['price'],
        'user': element!['user'],
        'image': element!['url'],
        'availability': element!['availability'],
        'id': id.length,
      });
      await updateProduct(
          name: element!['name'],
          description: element!['description'],
          weight: element!['weight'],
          price: element!['price'],
          user: element!['user'],
          imagen: element!['url'],
          cantidad: element!['availability'].toInt(),
          id: element!['id'],
          type: 1);

          await deleteAllDocumentsInCollection("cart");
    } catch (e) {
      print('Error al agregar el producto: $e');
    }
  });
}

Future<void> deleteAllDocumentsInCollection(String collectionName) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection(collectionName);

  QuerySnapshot querySnapshot = await collectionReference.get();

  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    await collectionReference.doc(documentSnapshot.id).delete();
  }
}

Future<void> addProductToCart({
  required String name,
  required String description,
  required String weight,
  required String price,
  required String user,
  required imagen,
  required int cantidad,
  required int id,
}) async {
  CollectionReference productsCollection = db.collection('cart');
  try {
    await productsCollection.add({
      'name': name,
      'description': description,
      'weight': weight,
      'price': price,
      'user': user,
      'image': imagen,
      'availability': cantidad.toDouble(),
      'id': id,
    });
    print('Producto agregadoal carrito con éxito');
  } catch (e) {
    print('Error al agregar el producto al carrito: $e');
  }
}

Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
  try {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.png');

    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

    if (taskSnapshot.state == TaskState.success) {
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } else {
      return null;
    }
  } catch (e) {
    print('Error al subir la imagen: $e');
    return null;
  }
}

Future<void> updateProduct({
  required int id, // El ID del producto que deseas actualizar
  required String name,
  required String description,
  required String weight,
  required String price,
  required String user,
  required imagen,
  required int cantidad,
  int? type,
}) async {
  CollectionReference productsCollection = db.collection('products');
  var url = type == null ? await uploadImageToFirebaseStorage(imagen) : imagen;

  try {
    // Realiza una consulta para buscar el documento con el campo "id" igual al valor proporcionado
    QuerySnapshot querySnapshot =
        await productsCollection.where('id', isEqualTo: id).get();
    // Comprueba si se encontró algún documento que cumpla con el criterio de búsqueda
    if (querySnapshot.docs.isNotEmpty) {
      // Actualiza el primer documento encontrado (puedes ajustar la lógica si esperas encontrar más de uno)
      DocumentSnapshot productDoc = querySnapshot.docs.first;
      DocumentReference productRef = productDoc.reference;

      await productRef.update({
        'name': name,
        'description': description,
        'weight': weight,
        'price': price,
        'user': user,
        'image': url,
        'availability': type != null ? cantidad : cantidad.toDouble(),
      });

      print('Producto actualizado con éxito');
    } else {
      print('No se encontró ningún producto con el ID proporcionado.');
    }
  } catch (e) {
    print('Error al actualizar el producto: $e');
  }
}

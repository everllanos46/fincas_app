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

Future<List<Map<String, dynamic>?>> getBuysList(String username) async {
  CollectionReference collectionReference = db.collection('buys');
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
    String telefono, String user, imagen) async {
  CollectionReference collectionReference = db.collection('users');
  var url = await uploadImageToFirebaseStorage(imagen);
  await collectionReference.add({
    'email': email,
    'password': password,
    'role': role,
    'telefono': telefono,
    'user': user,
    "imagen": url
  });
}

Future<bool> addProduct({
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
    return true;
  } catch (e) {
    print('Error al agregar el producto: $e');
    return false;
  }
}

Future<bool> buyCart(List<Map<String, dynamic>?> products,
    Map<String, dynamic> user, String url) async {
  var total = 0;
  var totalCantidad = 0;
  var fecha = DateTime.now().toLocal();
  try {
    products.forEach((element) async {
      total = total + int.parse(element!['price']);
      var availabilityStr = element!['availability'];
      // double availabilityDouble = double.parse(availabilityStr);
      int availabilityInt = availabilityStr.toInt();

      totalCantidad = totalCantidad + availabilityInt;
      CollectionReference productsCollection = db.collection('products');
      var id = await geProducts();
      await productsCollection.add({
        'name': element!['name'],
        'description': element!['description'],
        'weight': element!['weight'],
        'price': element!['price'],
        'user': element!['user'],
        'image': element!['image'],
        'availability': element!['availability'],
        'id': id.length,
      });
      await updateProduct(
          name: element!['name'],
          description: element!['description'],
          weight: element!['weight'],
          price: element!['price'],
          user: element!['user'],
          imagen: element!['image'],
          cantidad: element!['availability'].toInt(),
          id: element!['id'],
          type: 1);

      await deleteAllDocumentsInCollection("cart", user!['user']);
      
    });
    CollectionReference buysCollection = db.collection('buys');
    await buysCollection.add({
      'total': total,
      'totalCantidad': totalCantidad,
      'date': fecha,
      'user': user!['user'],
      'file': url
    });
    return true;
  } catch (e) {
    return false;
    print("Error al momento de comprar el carrito");
  }
}

Future<void> deleteAllDocumentsInCollection(
    String collectionName, String username) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection(collectionName);

  QuerySnapshot querySnapshot =
      await collectionReference.where('user', isEqualTo: username).get();

  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    await collectionReference.doc(documentSnapshot.id).delete();
  }
}

Future<bool> addProductToCart({
  required String name,
  required String description,
  required String weight,
  required String price,
  required String user,
  required imagen,
  required int cantidad,
  required int id,
  required cantidadMax
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
      'max': cantidadMax
    });
    print('Producto agregadoal carrito con éxito');
    return true;
  } catch (e) {
    print('Error al agregar el producto al carrito: $e');
    return false;
  }
}

Future<bool> deleteProduct({required int id}) async {
  try {
    CollectionReference productsCollection = db.collection('products');

    // Realizar una consulta para encontrar el documento con el campo 'id' coincidente
    QuerySnapshot querySnapshot =
        await productsCollection.where('id', isEqualTo: id).get();

    // Verificar si se encontraron documentos
    if (querySnapshot.docs.isNotEmpty) {
      // Eliminar el primer documento encontrado (asumimos que 'id' es único)
      await querySnapshot.docs.first.reference.delete();
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error al eliminar el producto: $e');
    return false;
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

Future<String> uploadDocuments(File imageFile) async {
  try {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage
        .ref()
        .child('files/${DateTime.now().millisecondsSinceEpoch}.pdf');

    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

    if (taskSnapshot.state == TaskState.success) {
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } else {
      return "";
    }
  } catch (e) {
    print('Error al subir la imagen: $e');
    return "";
  }
}

Future<bool> updateUserCollection({
  required String email,
  required String password,
  required String user,
  required String role,
  required String telefono,
  File? imagen,
}) async {
  CollectionReference collectionReference = db.collection('users');

  QuerySnapshot querySnapshot =
      await collectionReference.where('user', isEqualTo: user).get();
  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic> updateData = {
      'email': email,
      'password': password,
      'user': user,
      'role': role,
      'telefono': telefono
    };

    if (imagen != null) {
      var url = await uploadImageToFirebaseStorage(imagen);
      updateData['imagen'] = url;
    }

    await querySnapshot.docs.first.reference.update(updateData);
    return true;
  } else {
    print('Documento no encontrado para el usuario $user');
    return false;
  }
}

Future<bool> updateProduct({
  required int id,
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
  String? urlRecibed;

  if (imagen is File) {
    urlRecibed = imagen.path;
  } else if (imagen is String) {
    urlRecibed = imagen;
  } else {
    urlRecibed = null;
  }

  var url = type == null ? await uploadImageToFirebaseStorage(imagen) : urlRecibed;

  try {
    QuerySnapshot querySnapshot =
        await productsCollection.where('id', isEqualTo: id).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot productDoc = querySnapshot.docs.first;
      DocumentReference productRef = productDoc.reference;

      await productRef.update({
        'name': name,
        'description': description,
        'weight': weight,
        'price': price,
        'user': user,
        'image': url,
        'availability': type != null
            ? productDoc['availability'] - cantidad
            : cantidad.toDouble(),
      });

      print('Producto actualizado con éxito');
      return true;
    } else {
      print('No se encontró ningún producto con el ID proporcionado.');
    }
  } catch (e) {
    print('Error al actualizar el producto: $e');
  }
  return false;
}


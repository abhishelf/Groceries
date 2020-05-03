import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/modal/Grocery.dart';

class FetchGroceryList extends GroceryRepository {
  final databaseReference = Firestore.instance;

  @override
  Future<List<Grocery>> fetchGroceryList() async {
    List<Grocery> grocery = List();

    await databaseReference
        .collection("grocery")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      try {
        snapshot.documents.forEach((f) {
          Grocery g = Grocery(
              id: f.documentID,
              image: f.data['image'],
              title: f.data['title'],
              quantity: f.data['quantity'],
              price: f.data['price']);
          grocery.add(g);
        });
      } catch (error) {
        throw FetchDataException("Error While Fetching Grocery : [$error]");
      }
    }).catchError((error) => throw FetchDataException("Error While Fetching Grocery : [$error]"));

    return grocery;
  }
}

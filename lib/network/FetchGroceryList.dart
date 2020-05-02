import 'package:grocery/modal/Grocery.dart';
import 'package:firebase_database/firebase_database.dart';

class FetchGroceryList extends GroceryRepository{

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Future<List<Grocery>> fetchGroceryList() {
    List<Grocery> grocery = List();
    databaseReference.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      return grocery;
    });
  }

}
class Grocery {
  String id;
  String image;
  String title;
  String price;
  String quantity;

  Grocery({this.id, this.image, this.title, this.price, this.quantity});
}

abstract class GroceryRepository {
  Future<List<Grocery>> fetchGroceryList();
}

class FetchDataException implements Exception {
  final _message;

  FetchDataException([this._message]);

  String toString() {
    if (_message == null) return "Error While Fetching Grocery List";
    return _message;
  }
}

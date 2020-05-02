class History {

  String id;
  String title;
  String image;
  String quantity;
  String q;
  String price;
  String date;

  History({this.id, this.title, this.image, this.quantity, this.q, this.price,
      this.date});
}

abstract class HistoryRepository {
  Future<List<History>> fetchHistoryList();
}

class FetchDataException implements Exception {
  final _message;

  FetchDataException([this._message]);

  String toString() {
    if (_message == null) return "Error While Fetching History List";
    return _message;
  }
}
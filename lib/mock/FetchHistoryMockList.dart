import 'package:aaharpurti/modal/History.dart';

class FetchHistoryMockList implements HistoryRepository {
  @override
  Future<List<History>> fetchHistoryList() {
    return new Future.value(history);
  }
}

var history = <History>[
  History(
      id: "1",
      image: "images/apple.jpg",
      title: "Apple",
      quantity: "1 kg",
      price: "110",
      q: "2",
      date: "22/10/2020",
      status: "0"),
  History(
      id: "2",
      image: "images/apple.jpg",
      title: "Apple",
      quantity: "1 kg",
      price: "220",
      q: "3",
      date: "21/10/2020",
      status: "1"),
  History(
      id: "3",
      image: "images/apple.jpg",
      title: "Apple",
      quantity: "3 kg",
      price: "110",
      q: "4",
      date: "20/10/2020",
      status: "1"),
];

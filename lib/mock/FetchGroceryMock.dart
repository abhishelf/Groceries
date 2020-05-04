import 'package:grocery/modal/Grocery.dart';

class FetchGroceryMock implements GroceryRepository {
  @override
  Future<List<Grocery>> fetchGroceryList() {
    return new Future.value(groceryList);
  }
}

var groceryList = <Grocery>[
  Grocery(
      id: "1",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "2",
      image: "images/apple.jpg",
      title: "Apple",
      price: "340",
      quantity: "1 kg"),
  Grocery(
      id: "3",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "4",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "5",
      image: "images/apple.jpg",
      title: "Apple",
      price: "340",
      quantity: "1 kg"),
  Grocery(
      id: "6",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "7",
      image: "images/apple.jpg",
      title: "Apple",
      price: "340",
      quantity: "1 kg"),
  Grocery(
      id: "8",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "9",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "10",
      image: "images/apple.jpg",
      title: "Apple",
      price: "340",
      quantity: "1 kg"),
  Grocery(
      id: "11",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "12",
      image: "images/apple.jpg",
      title: "Apple",
      price: "340",
      quantity: "1 kg"),
  Grocery(
      id: "13",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "14",
      image: "images/apple.jpg",
      title: "Mango",
      price: "220",
      quantity: "1 kg"),
  Grocery(
      id: "15",
      image: "images/apple.jpg",
      title: "Apple",
      price: "340",
      quantity: "1 kg"),
];

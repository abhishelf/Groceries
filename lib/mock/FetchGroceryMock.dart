import 'package:grocery/modal/Grocery.dart';

class FetchGroceryMock implements GroceryRepository{

  @override
  Future<List<Grocery>> fetchGroceryList() {
    return new Future.value(groceryList);
  }
}

var groceryList = <Grocery>[
  Grocery(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Apple",price: "340",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Apple",price: "340",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Apple",price: "340",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Apple",price: "340",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Apple",price: "340",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Apple",price: "340",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
  Grocery(image: "images/mock_fruit.jpeg",title: "Apple",price: "340",quantity: "1 kg"),
];
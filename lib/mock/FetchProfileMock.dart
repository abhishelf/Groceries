import 'package:grocery/modal/Cart.dart';
import 'package:grocery/modal/Profile.dart';
import 'package:grocery/modal/Wishlist.dart';

class FetchProfileMock implements ProfileRepository{

  @override
  Future<Profile> fetchProfile(String email) {
    return new Future.value(profile);
  }
}

Profile profile = Profile(
  name: "Abhishek",
  address: "birla insitute of technology, Samanpura, BIT Campus, Patna, Bihar 800014",
  email: "imabhishek.dev@gmail.com",
  phone: "7050316935",
  cartList: [
    Cart(image: "images/mock_fruit.jpeg",title: "Mango",price: "110",quantity: "1 kg",cartQ: "2"),
    Cart(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg",cartQ: "1"),
    Cart(image: "images/mock_fruit.jpeg",title: "Mango",price: "110",quantity: "1 kg",cartQ: "3"),
    Cart(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg",cartQ: "2"),
    Cart(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg",cartQ: "1"),
  ],
  wishlist: [
    Wishlist(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
    Wishlist(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
    Wishlist(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
    Wishlist(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
    Wishlist(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
    Wishlist(image: "images/mock_fruit.jpeg",title: "Mango",price: "220",quantity: "1 kg"),
  ]
);
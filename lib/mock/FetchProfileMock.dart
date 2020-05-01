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
);
import 'package:grocery/modal/Cart.dart';
import 'package:grocery/modal/Wishlist.dart';

class Profile {
  String name;
  String phone;
  String email;
  String address;

  List<Cart> cartList;
  List<Wishlist> wishlist;

  Profile({this.name, this.phone, this.email, this.address, this.cartList,
      this.wishlist});
}


abstract class ProfileRepository {
  Future<Profile> fetchProfile(String email);
}

class FetchDataException implements Exception {
  final _message;

  FetchDataException([this._message]);

  String toString() {
    if (_message == null) return "Error While Fetching Profile";
    return _message;
  }
}
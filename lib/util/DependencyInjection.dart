import 'package:grocery/mock/FetchGroceryMock.dart';
import 'package:grocery/mock/FetchProfileMock.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/modal/Profile.dart';

enum Flavor { MOCK, PROD }

class Injector {

  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  GroceryRepository get groceryRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return FetchGroceryMock();
      default:
        return null;
    }
  }

  ProfileRepository get profileRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return FetchProfileMock();
      default:
        return null;
    }
  }


}
import 'package:grocery/mock/FetchGroceryMock.dart';
import 'package:grocery/mock/FetchHistoryMockList.dart';
import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/modal/Placed.dart';
import 'package:grocery/network/FetchGroceryList.dart';
import 'package:grocery/network/FetchHistoryList.dart';

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
        return FetchGroceryList();
    }
  }

  HistoryRepository get historyRepository {
    switch(_flavor){
      case Flavor.MOCK :
         return FetchHistoryMockList();
      default:
        return FetchHistoryList();
    }
  }


}
import 'package:aaharpurti/mock/FetchGroceryMock.dart';
import 'package:aaharpurti/mock/FetchHistoryMockList.dart';
import 'package:aaharpurti/modal/Grocery.dart';
import 'package:aaharpurti/modal/History.dart';
import 'package:aaharpurti/network/FetchGroceryList.dart';
import 'package:aaharpurti/network/FetchHistoryList.dart';

enum Flavor { MOCK, PROD }

class Injector {

  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;

  static void configure(Flavor flavor) {
    _flavor = flavor;
  }

  static Flavor getFlavor(){
    return _flavor;
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
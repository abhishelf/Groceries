import 'package:grocery/modal/Grocery.dart';
import 'package:grocery/util/DependencyInjection.dart';

abstract class GroceryListViewContract {
  void onLoadGrocery(List<Grocery> groceryList);

  void onLoadException(String error);
}

class GroceryPresenter {
  GroceryListViewContract _viewContract;
  GroceryRepository _repository;

  GroceryPresenter(this._viewContract) {
    _repository = Injector().groceryRepository;
  }

  void loadGroceryList() {
    _repository
        .fetchGroceryList()
        .then((value) => _viewContract.onLoadGrocery(value))
        .catchError(
            (onError) => _viewContract.onLoadException(onError.toString()));
  }
}

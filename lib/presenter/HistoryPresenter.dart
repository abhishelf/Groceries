import 'package:grocery/modal/History.dart';
import 'package:grocery/util/DependencyInjection.dart';

abstract class HistoryListViewContract {
  void onLoadHistory(List<History> historyList);

  void onLoadException(String error);
}

class HistoryPresenter {
  HistoryListViewContract _viewContract;
  HistoryRepository _repository;

  HistoryPresenter(this._viewContract) {
    _repository = Injector().historyRepository;
  }

  void loadHistoryList() {
    _repository
        .fetchHistoryList()
        .then((value) => _viewContract.onLoadHistory(value))
        .catchError(
            (onError) => _viewContract.onLoadException(onError.toString()));
  }
}

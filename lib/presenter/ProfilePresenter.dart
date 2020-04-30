import 'package:grocery/modal/Profile.dart';
import 'package:grocery/util/DependencyInjection.dart';

abstract class ProfileViewContract{
  void onLoadProfile(Profile profile);

  void onLoadException(String error);
}

class ProfilePresenter{

  ProfileViewContract _viewContract;
  ProfileRepository _repository;

  ProfilePresenter(this._viewContract){
    _repository = Injector().profileRepository;
  }

  void loadProfile(String email){
    _repository.fetchProfile(email)
        .then((value) => _viewContract.onLoadProfile(value))
        .catchError((onError) => _viewContract.onLoadException(onError.toString()));
  }
}
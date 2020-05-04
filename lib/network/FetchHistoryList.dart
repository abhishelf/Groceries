import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery/modal/History.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchHistoryList extends HistoryRepository {

  @override
  Future<List<History>> fetchHistoryList() async{
    List<History> list = List();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String email = sharedPreferences.getString("EMAIL");

    await Firestore.instance.collection("orders").getDocuments().then((QuerySnapshot snapshot){
      try {
        snapshot.documents.forEach((f) {
          //FIXME replace A with #
         if(f.documentID.split("A")[0].trim() == email.trim()){
           for(int i=0;i<f.data['cart'].length;i++){
             List<String> splt = f.data['cart'][i].split("@");
             History history = History(
               title: splt[0],
               price: splt[1],
               q: splt[2],
               quantity: splt[3],
               image: splt[4],
               date: f.data['date'],
               id: f.documentID
             );
             list.add(history);
           }
         }
        });
      } catch (error) {
        throw FetchDataException("Error While Fetching History : [$error]");
      }
    }).catchError((error) => throw FetchDataException("Error While Fetching History : [$error]"));

    return list;
  }

}
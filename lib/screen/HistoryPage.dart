import 'package:flutter/material.dart';
import 'package:grocery/modal/History.dart';
import 'package:grocery/presenter/HistoryPresenter.dart';
import 'package:grocery/util/BaseAuth.dart';
import 'package:grocery/util/DependencyInjection.dart';
import 'package:grocery/util/MyNavigator.dart';
import 'package:grocery/util/String.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    implements HistoryListViewContract {
  HistoryPresenter _historyPresenter;
  List<History> _historyList;
  bool _isLoading;

  _HistoryPageState() {
    _historyPresenter = HistoryPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _historyPresenter.loadHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TITLE_ORDER_HISTORY,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              Auth().signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _historyList == null || _historyList.length == 0
              ? Center(
                  child: Text(ERROR_NONE),
                )
              : ListView.builder(
                  itemCount: _historyList.length,
                  itemBuilder: (context, index) {
                    return _getHistoryListItem(index);
                  },
                ),
    );
  }

  Widget _getHistoryListItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: Injector.getFlavor() == Flavor.PROD
                        ? NetworkImage(_historyList[index].image)
                        : AssetImage(_historyList[index].image),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Text(
                      _historyList[index].quantity,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(left: 16.0)),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _historyList[index].title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        RS + _historyList[index].price,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 35.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Q : " + _historyList[index].q,
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _historyList[index].date,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.4,
        )
      ],
    );
  }

  @override
  void onLoadException(String error) {
    setState(() {
      _isLoading = false;
      _historyList = List();
    });
  }

  @override
  void onLoadHistory(List<History> historyList) {
    setState(() {
      _isLoading = false;
      _historyList = historyList;
    });
  }
}

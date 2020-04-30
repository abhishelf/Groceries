import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grocery/modal/Profile.dart';
import 'package:grocery/modal/ProfileItem.dart';
import 'package:grocery/util/String.dart';

class ProfileScreen extends StatefulWidget {
  Profile profile;

  ProfileScreen({Key key,this.profile}): super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileItem> _itemList;

  String _name = "Abhishek";
  String _phone = "7050316935";
  String _address = "birla insitute of technology, Samanpura, BIT Campus, Patna, Bihar 800014";

  @override
  void initState() {
    super.initState();
    _itemList = [
      ProfileItem(Icons.person,"Name",_name),
      ProfileItem(Icons.phone_android,"Phone",_phone),
      ProfileItem(Icons.location_on,"Delivery Address",_address),
//      ProfileItem(Icons.lock,"Change Password",null),
      ProfileItem(Icons.exit_to_app,"Exit",null),
      ProfileItem(Icons.security,"Logout",null),
    ];
  }

  void _handleListClick(BuildContext context, int index){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PROFILE_TITLE,style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: _itemList.length,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){
              _handleListClick(context, index);
            },
            child: _getListTile(index)
          );
        },
      ),
    );
  }

  Widget _getListTile(int index){
    if(_itemList[index].subtitle == null){
      return ListTile(
        trailing: Icon(Icons.keyboard_arrow_right,color: Colors.grey,),
        leading: Icon(_itemList[index].leadingIcon,color: Colors.grey,),
        title: Text(
          _itemList[index].title,
          style: TextStyle(
              color: Colors.black,
              fontSize: 22.0
          ),
        ),
      );
    }

    return ListTile(
      trailing: Icon(Icons.keyboard_arrow_right,color: Colors.grey,),
      leading: Icon(_itemList[index].leadingIcon,color: Colors.grey,),
      title: Text(
        _itemList[index].title,
        style: TextStyle(
            color: Colors.black,
            fontSize: 22.0
        ),
      ),
      subtitle: Text(
        _itemList[index].subtitle,
        style: TextStyle(
            color: Colors.black45,
            fontSize: 16.0
        ),
      ),
    );
  }


}

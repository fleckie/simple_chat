import 'package:flutter/material.dart';
import 'package:simplechat/services/firestoreHelper.dart';
import 'userListTile.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();

}
class _UserListState extends State<UserList> {
  Stream userList;

  @override
  void initState() {
    getUserList();
    super.initState();
  }

  getUserList() async {
    FirestoreHelper().getAllUsers().then((snapshots) {
      setState(() {
        userList = snapshots;
    });
  });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userList,
        builder: (context, snapshot) {
          return (snapshot.hasData)
              ? Expanded (
            child:
          ListView.builder(
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return UserListTile(
                  userName: snapshot
                      .data.documents[index].data["userName"].toString()
                );
              }))
              : Container();
        });
  }
}
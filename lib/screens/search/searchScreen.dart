import 'package:flutter/material.dart';
import 'package:simplechat/services/firestoreHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simplechat/themes/textStyle.dart';
import 'package:simplechat/widgets/widgets.dart';
import 'results.dart';
import 'userList.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  FirestoreHelper firestoreHelper = FirestoreHelper();
  TextEditingController searchController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool searchFinished = false;

  initiateSearch() async {
    if(searchController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await firestoreHelper.searchByName(searchController.text)
          .then((snapshot){
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          searchFinished = true;
        });
      });
    }
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :  Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                          hintText: "search username ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child:  Icon(Icons.search),
                  )
                ],
              ),
            ),
            searchFinished ?
            results(searchResultSnapshot, context):
                UserList()
          ],
        ),
      ),
    );
  }
}


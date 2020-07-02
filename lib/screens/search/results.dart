import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'resultTile.dart';


Widget results(QuerySnapshot results, BuildContext context){
  return ListView.builder(
      shrinkWrap: true,
      itemCount: results.documents.length,
      itemBuilder: (context, index){
        return resultTile(
          results.documents[index].data["userName"] != null?
          results.documents[index].data["userName"] :
              "No User Found"
            ,
          results.documents[index].data["userMail"] != null?
          results.documents[index].data["userMail"]:
          "No User Found",
          context
        );
      });
}
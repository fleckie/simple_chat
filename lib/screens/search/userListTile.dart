import 'package:flutter/material.dart';
import 'package:simplechat/services/chatHelper.dart';
import 'package:simplechat/services/constants.dart';


class UserListTile extends StatelessWidget {
  final String userName;

  UserListTile({this.userName});

  @override
  Widget build(BuildContext context) {
    return
      userName != Constants.myName ?
      GestureDetector(
      onTap: (){
        enterChat(userName, context);
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Color(0xff007EF4),
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child:
              Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300))),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    ):
    Container();
  }
}

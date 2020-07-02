import 'package:simplechat/services/sharedPreferencesHelper.dart';
import 'package:simplechat/themes/theme.dart';
import 'package:simplechat/services/auth.dart';
import 'package:simplechat/services/firestoreHelper.dart';
import 'package:simplechat/screens/chatList/chatListScreen.dart';
import 'package:simplechat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simplechat/themes/textStyle.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login(this.toggleView);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthService authService = new AuthService();
  final formKey = GlobalKey<FormState>();


  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInEmail(
          emailController.text, passwordController.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
          await FirestoreHelper().getUserInfo(emailController.text);

          SharedPreferencesHelper.saveLoginStatus(true);
          SharedPreferencesHelper.saveActiveUserName(
              userInfoSnapshot.documents[0].data["userName"]);
          SharedPreferencesHelper.saveActiveUserMail(
              userInfoSnapshot.documents[0].data["userMail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatListScreen()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            SizedBox(
              height: 40,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      return RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)
                          ? null
                          : "Please Enter Correct Email";
                    },
                    controller: emailController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("email"),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                      return val.length > 6
                          ? null
                          : "Enter Password 6+ characters";
                    },
                    style: simpleTextStyle(),
                    controller: passwordController,
                    decoration: textFieldInputDecoration("password"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 32,
            ),
            GestureDetector(
              onTap: () {
                signIn();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueGrey,
                      Colors.blueGrey],
                    )),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Sign In",
                  style: biggerTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
        GestureDetector(
          onTap:() {
            authService.signInWithGoogle(context);
          },
          child:
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Sign In with Google",
                style:
                TextStyle(fontSize: 17, color: CustomTheme.textColor),
                textAlign: TextAlign.center,
              ),
            )),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account? ",
                  style: simpleTextStyle(),
                ),
                GestureDetector(
                  onTap: () {
                    widget.toggleView();
                  },
                  child: Text(
                    "Register now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

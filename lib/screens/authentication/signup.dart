import 'package:flutter/material.dart';
import 'package:simplechat/themes/textStyle.dart';
import 'package:simplechat/widgets/widgets.dart';
import 'package:simplechat/services/auth.dart';
import 'package:simplechat/services/firestoreHelper.dart';
import 'package:simplechat/services/sharedPreferencesHelper.dart';
import 'package:simplechat/screens/chatList/chatListScreen.dart';

class Signup extends StatefulWidget {
  final Function toggleView;
  Signup(this.toggleView);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthService authService = new AuthService();
  FirestoreHelper firestoreHelper = FirestoreHelper();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signUp() async {
    // checks if all the fields were filled in properly
    if (formKey.currentState.validate()) {
      setState(() {
        // a progress indicator will be shown if isLoading = true
        isLoading = true;
      });
      await authService
          .signUpEmail(emailController.text, passwordController.text)
          .then((result) {
        if (result != null) {
          // creates a map of the filled in fields and passes it to the firestoreHelper
          Map<String,String> userDataMap = {
            "userName" : usernameController.text,
            "userMail" : emailController.text
          };
          firestoreHelper.addUserInfo(userDataMap);

          SharedPreferencesHelper.saveLoginStatus(true);
          SharedPreferencesHelper.saveActiveUserName(usernameController.text);
          SharedPreferencesHelper.saveActiveUserMail(emailController.text);

        Navigator.pushReplacement(
            (context), MaterialPageRoute(builder: (context) => ChatListScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
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
                          style: simpleTextStyle(),
                          controller: usernameController,
                          validator: (val) {
                            return val.isEmpty || val.length < 3
                                ? "Enter Username 3+ characters"
                                : null;
                          },
                          decoration: textFieldInputDecoration("Username"),
                        ),
                        TextFormField(
                          controller: emailController,
                          style: simpleTextStyle(),
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Enter correct email";
                          },
                          decoration: textFieldInputDecoration("Email"),
                        ),
                        TextFormField(
                          obscureText: true,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Password"),
                          controller: passwordController,
                          validator: (val) {
                            return val.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () {
                      signUp();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Colors.blueGrey,
                              Colors.blueGrey
                            ],
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Sign Up",
                        style: biggerTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: simpleTextStyle(),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: Text(
                          "Go to Login",
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

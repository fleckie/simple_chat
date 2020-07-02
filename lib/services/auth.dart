import 'package:firebase_auth/firebase_auth.dart';
import 'package:simplechat/models/users.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simplechat/screens/chatList/chatListScreen.dart';
import 'package:simplechat/services/firestoreHelper.dart';
import 'sharedPreferencesHelper.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreHelper firestoreHelper = FirestoreHelper();

  User _userFromFireBaseUser (FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future signInEmail (String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    }catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
    await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = await _auth.signInWithCredential(credential);

    Map<String,String> userDataMap = {
      "userName" : result.user.displayName,
      "userMail" : result.user.email
    };
    firestoreHelper.addUserInfo(userDataMap);

    SharedPreferencesHelper.saveLoginStatus(true);
    SharedPreferencesHelper.saveActiveUserName(result.user.displayName);
    SharedPreferencesHelper.saveActiveUserMail(result.user.email);

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatListScreen()));

  }

  // adds the user to the firestore
  Future signUpEmail (String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFireBaseUser(user);
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: (email));
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }



}
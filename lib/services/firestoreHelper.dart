import 'package:cloud_firestore/cloud_firestore.dart';

// This class helps with managing the Collection "Users" in the Firestore
class FirestoreHelper {
  // Singleton Implementation
  static final FirestoreHelper _firestoreHelper = FirestoreHelper._internal();
  factory FirestoreHelper() {
    return _firestoreHelper;
  }
  FirestoreHelper._internal();

/*Adds the user´s info to the "User"-Collection in the Firestore.
This has to be done on top of authenticating/registering the user.
 */

  Future<void> addUserInfo(userData) async {

    var exists = await userAlreadyExists(userData['userName']);
    if (!exists){
      Firestore.instance.collection("users").add(userData).catchError((e) {
        print(e.toString());
      });
    }
    else {
      print("user already exists");
    }

  }

  Future<bool> userAlreadyExists(String userName) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

  getUserChats(String userName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: userName)
        .snapshots();
  }

  getAllUsers() async {
    return await Firestore.instance
        .collection("users")
        .snapshots();
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  searchByName(String query) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: query)
        .getDocuments();
  }

  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData){
    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  Future<void> addPictureMessage(String chatRoomId, chatMessageData){
    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  Future<void> updateBio(String userName, String bio){
    Firestore.instance.collection("users")
        .where('userName', isEqualTo: userName)
        .getDocuments()
        .then((querySnapshot) {
          querySnapshot.documents.forEach((documentSnapshot){
            documentSnapshot.reference.updateData({"status": bio});
          });
    });
  }

  Future<void> updateProfilePicURL(String userName, String url){
    Firestore.instance.collection("users")
        .where('userName', isEqualTo: userName)
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((documentSnapshot){
        documentSnapshot.reference.updateData({"url": url});
      });
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userMail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }





}
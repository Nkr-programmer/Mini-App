import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_app/Models/recentlink.dart';
import 'package:mini_app/Models/user.dart' as Users;
import 'package:mini_app/Utils/utilities.dart';
import 'package:mini_app/classification/Subconstants.dart';

class FirebaseMethods
{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  GoogleSignIn _googleSignIn=GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //1
Future<User?> getCurrentUser() async {
    User? currentUser;
    currentUser = await _auth.currentUser;
    
    //it just gives us the idea some one is logedin(if yes who) or not
    return currentUser;
  }

  //2
 Future<User?> signIn() async{
GoogleSignInAccount? _signinAccount =await _googleSignIn.signIn();
GoogleSignInAuthentication _signinAuthentication =await _signinAccount!.authentication;

final AuthCredential credential 
=GoogleAuthProvider.credential(accessToken: 
_signinAuthentication.accessToken, idToken:_signinAuthentication.idToken );

UserCredential result = await _auth.signInWithCredential(credential);
User? user =result.user;
return user;
//FIRST _SIGNINACCOUNT TAKE THE DETAILS WHEN WE CLICK ON EMAILID
//THEN _SIGNINAUTHENTICATION TAKE THE AUTHENTICATION
//AND THEN CREDENDIAL 
//**  SIGNINWITHCREDENDIAL DIRECTLY SIGNIN WITH EMAIL ID
}


//3
  Future<bool> authenticateUser(User? user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user?.email)
        .get();
//** query from authentication which take is it already registered or not
// because if there is registered then dont need to pass the data again 
//else upload the data in database  AUTHENTICATION AND DATABASE 
//ARE DIFFERENT IN THIS AUTHENTICATION IS USED
    final List<DocumentSnapshot> docs = result.docs;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

//4
  Future<void> addDataToDb(User? currentUser) async {
    String? email = currentUser!.email;
    String username = Utilities.getUsername(email ?? "default");

    Users.User? user = Users.User(
        uid: currentUser.uid,
        email: currentUser.email ?? "default",
        name: currentUser.displayName ?? "default",
        profilePhoto: currentUser.photoURL ?? "default",
        username: username, 
        state: 5, status: "online",
        
        );
//this is to store currently loggedin user details to class user
var sap=user.toMap(user) as Map<String,dynamic>;
    firestore
        .collection("users").doc(currentUser.uid).set(sap);
//to send the all the login releated data to data base 

  }
//FROM 1 TO 4 GOOGLE SIGNIN
//signout is at end
//Now crud operations is started 
  final CollectionReference _linksCollection= firestore.collection("link");
 Future<void> addLinkToDb(RecentMessage recentMessage) async {
    var map = recentMessage.toMap();
  User? user;
  user =await _auth.currentUser;
  await     _linksCollection.doc(user?.uid).collection("nope").add(map);

//addToContacts(senderId:message.senderId,receiverId:message.receiverId)
  }
  Future<List<RecentMessage>> fetchAllLinks() async {
    List<RecentMessage> linksSets = new List<RecentMessage>.empty(growable:true);
  User? user;
  user =await _auth.currentUser;
  QuerySnapshot querySnapshot = await _linksCollection.doc(user?.uid).collection("nope").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) 
    { 
      linksSets.add(RecentMessage.fromMap(querySnapshot.docs[i].data() as Map<String,dynamic>));}
    linksSets.sort((a,b)=>a.addedOn.compareTo(b.addedOn));
     return linksSets;
  }
Future<bool> updateLinkToDb(Subconstants currentlink) async{
List<RecentMessage> linksSets= await  fetchAllLinks();
bool got=linksSets.any((element) => element.name==currentlink.name);
if(!got){return false;}
else{    
  User? user;
  user =await _auth.currentUser;
  QuerySnapshot querySnapshot = await _linksCollection.doc(user?.uid).collection("nope")
        .where("link_name", isEqualTo: currentlink.name)
        .get();
int numb=linksSets.where((element) => element.name==currentlink.name).elementAt(0).number;
        querySnapshot.docs[0].reference.update({
           "link_index": currentlink.index,
          "link_name":  currentlink.name,
          "link_brand": currentlink.brand,
          "link_url":   currentlink.url,
          "link_addedOn": Timestamp.now(),
          "link_number": numb+1,
          "link_image":   currentlink.image,
        });
       return true;}
}

  Future<bool> signOut() async {
  try{
      await _googleSignIn.signOut();
   await _auth.signOut();
    return true;
  }
  catch(e){
    return false;
  }
  }



Future<void> deleteLinkToDb(RecentMessage currentlink) async{

  User? user;
  user =await _auth.currentUser;
  QuerySnapshot querySnapshot = await _linksCollection.doc(user?.uid).collection("nope")
        .where("link_name", isEqualTo: currentlink.name)
        .get();
        querySnapshot.docs[0].reference.delete();
}
//     LIBRARY STUFF

//   static final Firestore _firestore = Firestore.instance;
//   final CollectionReference _messageCollection= _firestore.collection("post");
//   final CollectionReference _userCollection= _firestore.collection("users");
//   Future<void> addPostToDb(
//       MessageLib message, User sender) async {
//     var map = message.toMap();
//     await _messageCollection
//         .document(message.text)
//         .setData(map);

// addToContacts(text:message.text,senderId:message.senderId);
// }

//   void setImageMsg(String url, String senderId,int num,int num2,String text) async {
//     MessageLib message;

//     message = MessageLib.imageMessage(
//         message: "IMAGE",
//         senderId: senderId,
//         photoUrl: url,
//         timestamp: Timestamp.now(),
//         type: 'image',
//         num:num,
//         num2: num2,
//         text: text);

//     // create imagemap
//     var map = message.toImageMap();

//     // var map = Map<String, dynamic>();
//     await _messageCollection
//         .document(message.text)
//         .setData(map);

// addToContacts(text:message.text,senderId:message.senderId);
  
//   }
// DocumentReference getContactDocument({String of,String text})=>
//   _userCollection.document(of).collection("myLib").document(text);

//   void addToContacts({String text,String senderId}) async{
//     Timestamp currentTime = Timestamp.now();

//     await addToSendersContact(text, currentTime,senderId);
//   //  await addToReceiversContact(senderId, receiverId, currentTime);
//     }
//     Future<void> addToSendersContact(String text,currentTime,String senderId)async{
// DocumentSnapshot senderSnapshot= await getContactDocument(of:senderId,text:text).get();
  
//   if(!senderSnapshot.exists){
// Contact receiverContact = Contact(text:text,addedOn: currentTime);

// var receiverMap =receiverContact.toMap(receiverContact);
// await getContactDocument(of:senderId,text:text).setData(receiverMap);

//   }
  
//     }

// //     Future<void> addToReceiversContact(String senderId,String receiverId,currentTime)async{
// // DocumentSnapshot receiverSnapshot= await getContactDocument(of:receiverId ,forContact:senderId).get();
  
// //   if(!receiverSnapshot.exists){
// // Contact senderContact = Contact(uid:senderId,addedOn: currentTime);

// // var senderMap =senderContact.toMap(senderContact);
// // await getContactDocument(of:receiverId,forContact:senderId ).setData(senderMap);

// //   }
  
// //     }


// Stream<QuerySnapshot> fetchContacts({userId})  {

//  return  _userCollection.document(userId.uid).collection("myLib").snapshots();}

// // Stream <QuerySnapshot> fetchLastMessagesBetween({
// //   @required String senderId,
// //   @required String name})=>
// //  _messageCollection.document(name).snapshots().; 

//   Future<User> getUserDetailsbyId(id) async {
// try{  DocumentSnapshot documentSnapshot =
//         await _userCollection.document(id).get();

//     return User.fromMap(documentSnapshot.data);}
//     catch(e){
//       print(e);
//       return null;
//     }
  
//   }

}
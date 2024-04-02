import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_app/classification/Home_screen.dart';
import 'package:mini_app/data/firebase_repository.dart';
import 'package:mini_app/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyHomePage());
}

//keytool -list -v -keystore C:\Users\nikhil\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 FirebaseRepository _repository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
   // Firestore.instance.collection("users").document().setData({"name":"nkr_programmer"});
    return  MaterialApp(
        title:"Chromser",
        debugShowCheckedModeBanner: false,
     
theme: ThemeData(brightness: Brightness.dark),
        home: FutureBuilder(future:  _repository.getCurrentUser(), 
        builder:(context, AsyncSnapshot<User?> snapshot) {  
          if(snapshot.hasData)
          {return HomeScreen();}
          else
          {return LoginScreen();}
// when current user is clicked if null then loginscreen else homescreen
        },)
      );
  }
}

// FUTURE BUILDER IS THERE IN GOOGLE  SIGN IN ONLY

//error resolution
//1. srinker error or settining.dart :thats because add lines in android/app/setting.dart 
//and  this line in app/build.gradle multiDexEnabled true &&    this one also
//implementation 'com.android.support:multidex:1.0.3'  //with support libraries
//not this one this is in  //implementation 'androidx.multidex:multidex:2.0.1'  //with androidx libraries 
//for console test mode increase the time limit and for normal mode change false to true
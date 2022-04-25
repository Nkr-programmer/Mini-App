import 'package:flutter/cupertino.dart';
//import 'package:http/http.dart' as http;
import 'Subconstants.dart';
class Services{

static const String url ='https://jsonplaceholder.typicode.com/users';
static Future<List<Subconstants>> getSubs(BuildContext context) async{
try{
//final response=await http.get(url);
final response=await DefaultAssetBundle.of(context).loadString("assets/x.json");
  final List<Subconstants> subs=subconstantsFromJson(response);
return subs;
}catch(e){
return List<Subconstants>.empty();

}
}
}
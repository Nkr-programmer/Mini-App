class User{
late String uid;
late String name;
late String email;
late String username;
late String status;
late int state;
late String profilePhoto;

User({
required this.uid,
required this.name,
required this.email,
required this.username,
required this.status,
required this.state,
required this.profilePhoto,
});

Map toMap(User user){
var data = Map<String,dynamic>();
data["uid"]=user.uid;
data["name"]=user.name;
data["email"]=user.email;
data["username"]=user.username;
data["status"]=user.status;
data["state"]=user.state;
data["profilePhoto"]=user.profilePhoto;
return data;
//convert  user raw to map
}

User.fromMap(Map<String,dynamic>mapData){
  this.uid =mapData["uid"];
this.name=mapData["name"];
this.email=mapData["email"];
this.username=mapData["username"];
this.status=mapData["status"];
this.state=mapData["state"];
this.profilePhoto=mapData["profilePhoto"];
}
//retriveing from the map
}

//GOOGLE SIGNIN USED UP
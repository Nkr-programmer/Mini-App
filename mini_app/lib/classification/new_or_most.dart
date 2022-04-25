import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mini_app/Models/recentlink.dart';
import 'package:mini_app/classification/Home_screen.dart';
import 'package:mini_app/classification/Subconstants.dart';
import 'package:mini_app/data/firebase_methods.dart';
import 'package:snappable/snappable.dart';
import 'package:url_launcher/url_launcher.dart';
class NewOrMost extends StatefulWidget {
   final String name;

  const NewOrMost({Key? key,  required this.name}) : super(key: key);
  @override
  _NewOrMostState createState() => _NewOrMostState();
}

class _NewOrMostState extends State<NewOrMost> {
//   String name;
  //_NewOrMostState(this.name);
   FirebaseMethods _repository = FirebaseMethods();
  
   List<RecentMessage>? linksSets ;
 static final cont = GlobalKey<SnappableState>();
 late Subconstants subconstants ;
late Subconstants link;
late RecentMessage _recentMessage;
 uploadlink(){
{link=subconstants;

 _recentMessage =RecentMessage(
          index: link.index,
          name:  link.name,
          brand: link.brand,
          url:   link.url,
          image: link.image,
          addedOn: Timestamp.now(),
          number: 1,
       
        );
_repository.addLinkToDb(_recentMessage);}
}
void updateandcreate(){
   _repository.updateLinkToDb(subconstants).then((isNewUser) {
  if(isNewUser){print("yes");}
  else{uploadlink();}
});
}   
 Future<void> launchuniversal(String url)async{
if(await canLaunch(url)){
  final bool nativeApp =await launch(url,forceSafariVC: false,universalLinksOnly: true );
  if(!nativeApp){
    launch(url,forceSafariVC: true,);
  }
}

}
  Future<void> phoneCall(String url)async{
if(await canLaunch(url))
await launch(url);
   else{
     throw'could not resolve $url';
   }
  }
   @override
   
  void initState() {
    super.initState();
     _repository.fetchAllLinks().then((List<RecentMessage> list){
setState((){
  linksSets= list;
  if(widget.name=="Newest")
          {print("yes");}
          else
          { linksSets!.sort((a,b)=>a.number.compareTo(b.number));}
          print(linksSets!.elementAt(0).name);
         //  print(linksSets!.elementAt(1).name);
});
      
    
    });
  }
  @override
  Widget build(BuildContext context) {
//   void snaps() { setState(() {
    
//   });
// cont.currentState.snap();
// }
    Widget clock(List<RecentMessage>suggestionList,int index){
      return Slidable(
       actions: <Widget>[
    IconSlideAction(
      caption: 'Archive',
      color: Colors.blue,
      icon: Icons.archive,
      onTap: () => Scaffold.of(context).showSnackBar(new SnackBar(content:Text("Archive"))),
    ),
  ],
  secondaryActions: <Widget>[
    IconSlideAction(
      caption: 'Delete',
      color: Colors.red,
      icon: Icons.delete,
      onTap: () { setState(() { 
        _repository.deleteLinkToDb(linksSets!.elementAt(index));
       linksSets!.removeAt(index);       
      });
      }),
  ],
  actionPane: SlidableDrawerActionPane(),
  actionExtentRatio: 0.25,
      child: Container(
      
      child: GestureDetector(
              onTap: (){ 
              setState(() {
                subconstants=Subconstants(      index: suggestionList[index].index,
            name:  suggestionList[index].name,
            brand: suggestionList[index].brand,
            url:   suggestionList[index].url,
            image: suggestionList[index].image,
            );
              });updateandcreate();
                if(suggestionList[index].index==5){   phoneCall(suggestionList[index].url);}
                else
                if(suggestionList[index].name=="ORIGINAL"){ Navigator.push(context, MaterialPageRoute(builder: (context){return HomeScreen();}));}
                else
                   launchuniversal(suggestionList[index].url);
      
             },
        child: Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                    color: Colors.black54, boxShadow: [
                      BoxShadow(color: Colors.white.withAlpha(100), blurRadius: 10.0),
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  suggestionList[index].name,
                                  style: const TextStyle(fontSize: 23, color: Colors.white,fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  suggestionList[index].brand,
                                  style: const TextStyle(fontSize: 17, color: Colors.grey),
                                ),
                                
                              ],
                            ),
                          ),
                         
                           Padding(
                                                  padding: const EdgeInsets.only(left:70,bottom: 20.0),
                                                  child:    Container(
                                // decoration: BoxDecoration( boxShadow: [
                                //       BoxShadow(
                                //     color: Colors.white10,
                                //     spreadRadius: 1.0,
                                //     blurRadius: 2.0,
                                //     offset: Offset(3.0, 3.0))
                                //     ],),
                             height: 100,width:115,
                            child: ClipRRect(
                            
                                    borderRadius: BorderRadius.circular(20), 
                                     
                                      child:Image.network(
                                            suggestionList[index].image,
                                            fit: BoxFit.fill,
                                          ),
                                              ),
                                                ),),



                         
                         
                         
            //               Expanded(
            //                                 child: GestureDetector(
            //                             child: Image.network( suggestionList[index].image,
            //                     height: double.infinity,
                               
            //                   ),
            //                 onLongPress: (){ 
            //   setState(() {
            //     subconstants=Subconstants(      index: suggestionList[index].index,
            // name:  suggestionList[index].name,
            // brand: suggestionList[index].brand,
            // url:   suggestionList[index].url,
            // image: suggestionList[index].image,
            // );
            //   });updateandcreate();
            //     if(suggestionList[index].index==5){   phoneCall(suggestionList[index].url);}
            //     else
            //     if(suggestionList[index].name=="ORIGINAL"){ Navigator.push(context, MaterialPageRoute(builder: (context){return HomeScreen();}));}
            //     else
            //        launchuniversal(suggestionList[index].url);
      
            //  },),
            //               ),






                          
                        ],
                      ),
                    )),
      ),
    ),
  
 
          );}
    final List<RecentMessage> suggestionList = linksSets!=null?linksSets!.toList():[];
    return SafeArea(
          child: Scaffold(
         backgroundColor: Colors.black, appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon:Icon(Icons.arrow_back),
              color: Colors.white, onPressed: () {  Navigator.pop(context);  }, 
            ),
          ),
    
    body:Container(
  child:
    ListView.builder(itemCount:suggestionList.length,reverse:true,itemBuilder: (BuildContext context,int index){
      
          return Snappable(
    //key:cont,
    child:clock(suggestionList, index));
  }))
));
  }
}
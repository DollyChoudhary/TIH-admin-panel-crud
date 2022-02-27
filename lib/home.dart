import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            decoration: BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: Image.network(
                      "https://mars-metcdn-com.global.ssl.fastly.net/content/uploads/sites/101/2019/04/30162428/Top-Header-Background.png"
                  ).image,
                )
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  height: 62,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(

                        radius: 62,
                        backgroundImage: NetworkImage("https://miro.medium.com/max/11344/1*32h8ts3A-7XNr6A4Js87ng.jpeg"),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ADMIN NAME',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 3),

                          ),
                          Text('Admin',style: TextStyle(color: Colors.white),)
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Expanded(
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.network("https://cdn3.vectorstock.com/i/thumb-large/30/97/flat-business-man-user-profile-avatar-icon-vector-4333097.jpg",height: 120,),
                            Text('All Admin Members '),
                          ],
                        ),
                      ),

                      Card(
                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[


                            GestureDetector(

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  FoodForm()),
                                );
                              },

                            ),




                          ],


                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



class FoodForm extends StatefulWidget {
  @override
  _FoodFormState createState() => _FoodFormState();
}

class _FoodFormState extends State<FoodForm> {

  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("New Announcement"),
      ),
      body: BookList(),
      // ADD (Create)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Add"),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Title: ", textAlign: TextAlign.start,),
                      ),
                      TextField(

                        controller: titleController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("Author: "),
                      ),
                      TextField(
                        controller: authorController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () { Navigator.of(context).pop();},
                        child: Text("Undo", style: TextStyle(color: Colors.white),),),
                    ),

                    //Add Button

                    RaisedButton(

                      onPressed: () {
                        //TODO: Firestore create a new record code

                        Map<String, dynamic> newBook = new Map<String,dynamic>();
                        newBook["title"] = titleController.text;
                        newBook["author"] = authorController.text;

                        FirebaseFirestore.instance
                            .collection("books")
                            .add(newBook)
                            .whenComplete((){
                          Navigator.of(context).pop();
                        } );

                      },
                      child: Text("save", style: TextStyle(color: Colors.white),),
                    ),

                  ],
                );
              }
          );
        } ,
        tooltip: 'Add Title',
        child: Icon(Icons.add),
      ),
    );
  }
}


class BookList extends StatelessWidget {

  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    //TODO: Retrive all records in collection from Firestore
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError)
    return new Text('Error: ${snapshot.error}');
    switch (snapshot.connectionState) {
    case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
    default:
    return new ListView(

    padding: EdgeInsets.only(bottom: 80),
    children: snapshot.data!.docs.map((DocumentSnapshot document) {
    return Padding(
    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
    child: Card(
    child: ListTile(
    onTap: (){
    showDialog(
    context: context,
    builder: (BuildContext context){
    return AlertDialog(
    title: Text("Update Dilaog"),
    content: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Text("Title: ", textAlign: TextAlign.start,),
    TextField(
    controller: titleController,
    decoration: InputDecoration(
    hintText:  document['title'],
    ),
    ),
    Padding(
    padding: EdgeInsets.only(top: 20),
    child: Text("Author: "),
    ),
    TextField(
    controller: authorController,
    decoration: InputDecoration(
    hintText:  document['author'],

    ),
    ),
    ],
    ),
    actions: <Widget>[
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: RaisedButton(
    color: Colors.red,
    onPressed: () { Navigator.of(context).pop();},
    child: Text("Undo", style: TextStyle(color: Colors.white),),),
    ),
    // Update Button
    RaisedButton(
    onPressed: () {

    //TODO: Firestore update a record code

    Map<String, dynamic> updateBook = new Map<String,dynamic>();
    updateBook["title"] = titleController.text;
    updateBook["author"] = authorController.text;

    // Updae Firestore record information regular way
    FirebaseFirestore.instance
        .collection("books")
        .doc('title')
        .update(updateBook)
        .whenComplete((){
    Navigator.of(context).pop();
    });

    // Update firestore record information using a transaction to prevent any conflict in data changed from different sources
//                                         Firestore.instance.runTransaction((transaction) async {
// //                                          await transaction.update(document.reference, {'title': titleController.text, 'author': authorController.text })
//                                           await transaction.update(document.reference, updateBook)
//                                               .then((error){
//                                             Navigator.of(context).pop();
//                                           });
//                                         });
//                                       },


    child: Text("update",
    style: TextStyle(color: Colors.white),);}),


    ],
    );
    }
    );
    },
    title: new Text("Title " + document['title']),
    subtitle: new Text("Author " + document['author']),
    trailing:
    // Delete Button
    InkWell(
    onTap: (){
    //TODO: Firestore delete a record code
    FirebaseFirestore.instance
        .collection("books")
        .doc('title')
        .delete()
        .catchError((e){
    print(e);
    });


    }, child:
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Icon(Icons.delete),
    ),
    ),
    ),
    ),
    );
    }).toList(),
    );
    }
    },
    );
    }
  }
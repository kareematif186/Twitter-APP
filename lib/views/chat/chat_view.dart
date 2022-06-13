import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../constants.dart';

final _firestore =FirebaseFirestore.instance;
late User LoggedInUser ;

class ChatScreen extends StatefulWidget {

  static String id='chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTexrController =TextEditingController();
  final _auth =FirebaseAuth.instance;

  late String messageText;
  late bool  isTyping ;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();



  }


  void getCurrentUser()async{

    try {
      final user = await _auth.currentUser;

      if (user != null) {
        LoggedInUser = user;

        //print(LoggedInUser.email);
      }
    }catch(e){
      print(e);
    }

  }
/*

// not listen immedialty to firebase
_____________________________________________
  void getMessages()async{
    final messages=await _firestore.collection('messages').get();
    for( var message in messages.docs ){
      print(message.data());
    }
}

 */

  //listen immedialtly to changes to firebase // not used
  //______________________________________________

  void messagesStream() async{
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for( var message in snapshot.docs ){
        //  print(message.data());
      }
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(

        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(UniconsLine.forwaded_call , size: 30,),
              onPressed: () {


              }),

          IconButton(
              icon: const Icon(UniconsLine.video , size: 35),
              onPressed: () {


              }),


        ],
        //title: Text('Chat'),
        backgroundColor: Colors.black,

        title: Row(
          children: const [
/*
             IconButton(icon:const Icon(Icons.arrow_back),
               onPressed:() => Navigator.pop(context, false),
            ),

 */

            Expanded(

              child: ListTile(





                 // IconButton(icon:const Icon(Icons.arrow_back),
                 //   onPressed:() => Navigator.pop(context, false),
                  //),


                leading:

                CircleAvatar(
                       ///maxRadius: 25,

                      backgroundColor: Colors.white,

                     // radius: 30,

                      //child:
                      //Text(list1[i].name.substring(0,1)),
                      //
                      // ( "${list1[i].image}")
                      backgroundImage:
                      //NetworkImage("${list1[i].image}")

                      AssetImage('assets/avatar.png' )
                     //correct too




                  ),


                title: Text("Group" , style: TextStyle(color: Colors.white ,fontSize: 15 ,fontWeight: FontWeight.bold), ),

                subtitle:


                  Text(  "🟢 Active now" , style: TextStyle(color: Colors.grey ,fontSize: 9), ),







              ),
            ),
          ],
        ),

      ),




      body: SafeArea(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            MessagesStream(),

            Container(
              margin: const EdgeInsets.all(6.0),
              decoration: kMessageContainerDecoration,


              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  IconButton(icon: const Icon(UniconsLine.camera_change , color: Colors.blueAccent,
                    size:31 ,),
                      onPressed: () {}),



                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: messageTexrController,
                      onChanged: (value) {

                        messageText=value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(UniconsLine.microphone ,  color: Colors.blueAccent ,size: 29,),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo ,  color: Colors.blueAccent , size: 29,),
                    onPressed: () {},
                  ),


                  //RECORD
                  /*
                  SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent, shape: BoxShape.circle),
                    child: InkWell(
                      child: const Icon(
                        Icons.keyboard_voice,
                        color: Colors.white,
                      ),
                      onLongPress: () {
                      },
                    ),
                  ),


                   */



                  TextButton(
                    onPressed: () {
                      messageTexrController.clear();
                      _firestore.collection('messages').add({
                        'text':messageText,
                        'sender':LoggedInUser.email,
                        'date': DateTime.now().toIso8601String().toString(),


                      });


                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('date').snapshots(),
      builder: (context, snapshot){

        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.red,

            ),
          );

        }
        final messages =snapshot.data?.docs.reversed;
        List<MessageBubble>messageBubbles=[];
        for(var message  in messages!) {

          final messageText =message.data() as Map ;
          final messageText1 = messageText['text'];

          print(messageText1);

          final messageSender= message.data() as Map;
          final messageSender1 = messageSender['sender'];

          final currentUser = LoggedInUser.email;



          final messageBubble = MessageBubble(

            sender: messageSender1,
            text: messageText1,
            isMe: currentUser==messageSender1,

          );
          messageBubbles.add(messageBubble);

        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10 ,vertical: 20),
            children: messageBubbles,

          ),
        );

      },

    );
  }
}




class MessageBubble extends StatelessWidget {

  MessageBubble({required this.sender , required this.text , required this.isMe});
  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.01 , top: 6),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget> [

          //Text( sender , style: TextStyle(fontSize: 8.0, color: Colors.black,),),
          //Text( '' , style: TextStyle(fontSize: 1, color: Colors.black,),),


          Material(
              borderRadius:  isMe ? const BorderRadius.only(topLeft: Radius.circular((30.0)) ,
                  bottomLeft: Radius.circular(30) ,
                  bottomRight: Radius.circular(30))

                  : const BorderRadius.only(topRight: Radius.circular((30.0)) ,
                  bottomLeft: Radius.circular(30) ,
                  bottomRight: Radius.circular(30)),

              color: isMe ? Colors.blue : Colors.white12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 20),
                child: Text('$text' ,
                  style: TextStyle(
                    fontSize: 15,
                    color: isMe? Colors.white : Colors.white,

                  ),
                ),
              )
          ),
        ],
      ),

    );
  }
}





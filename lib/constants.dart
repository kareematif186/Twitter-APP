import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Message...........',
  hintStyle: TextStyle(color: Colors.grey ,fontSize: 15),
  labelStyle: TextStyle(color: Colors.white ,fontSize: 20) ,
  border: InputBorder.none,



);

const kMessageContainerDecoration =

BoxDecoration(

  color: Colors.white12,

  //shape: BoxShape.circle,


  borderRadius: BorderRadius.all(Radius.circular(30)),





  boxShadow: [
    BoxShadow(
        offset: Offset(0, 3),
        blurRadius: 5,
        color: Colors.black26)
  ],
);






const kTextFiledDecoration= InputDecoration(
  hintText: 'Enter a value'  ,

  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.red, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);




//from right to left move

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}





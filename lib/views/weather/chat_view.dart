/*
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
    );
  }
}

 */

import 'package:famlicious_app/views/weather/services/location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();



  }


  void getLocation() async{
   Location location = Location();
   await location.getcurrentLocation();

   print(location.latitude);
   print(location.longitude);

  }

  void getData() async {
    
    
   http.Response response= await http.get(Uri.parse('66aece9685b85440c591f90d06c78da2'));

   if(response.statusCode==200){
  String data=response.body;
  print(data);
  
  
  jsonDecode(data)['coord']['lon'];
}
else {
  print(response.statusCode);
}

   print(response.body);


  }



  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold();
  }
}


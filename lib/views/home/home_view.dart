import 'package:famlicious_app/views/auth/login_view.dart';
import 'package:famlicious_app/views/chat/chat_view.dart';
import 'package:famlicious_app/views/favourite/favourite_view.dart';
import 'package:famlicious_app/views/profile/profile_view.dart';
import 'package:famlicious_app/views/timeline/timeline_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int _currentIndex = 0;
  final List<Widget> _views = [
     TimelineView(),
    //const ChatView(),
    ChatScreen(),
    const FavouriteView(),
    const ProfileView()
  ];

  @override
  void initState() {
    isUserAuth();
    super.initState();
  }

  isUserAuth() {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _firebaseAuth.currentUser == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: IndexedStack(
              children: _views,
              index: _currentIndex,
            ),




            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).iconTheme.color,
              unselectedItemColor: Colors.white,
              showSelectedLabels: false,
              enableFeedback: false,
              showUnselectedLabels: false,

              items: const [
                BottomNavigationBarItem(

                    icon: Icon(UniconsLine.home_alt ,size: 30), label: 'Timeline' ,),
                BottomNavigationBarItem(
                    icon: Icon(UniconsLine.search, size: 30), label: 'Chat'),

                BottomNavigationBarItem(//comment_dots
                    icon: Icon(UniconsLine.heart ,size: 30 ), label: 'Favourite'),
                BottomNavigationBarItem(
                    icon: Icon(UniconsLine.user , size: 30), label: 'Profile')
              ],
            ),

             // last bottom navigatipn bar


/*
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () { },
          tooltip: 'Increment',
          child: Icon(Icons.add),
          elevation: 2.0,
          backgroundColor: Colors.blueAccent,
        ),

      bottomNavigationBar: BottomAppBar( //bottom navigation bar on scaffold
      color:Colors.black,
      shape: CircularNotchedRectangle(), //shape of notch
      notchMargin: 5, //notche margin between floating button and bottom appbar
      child: Row( //children inside bottom appbar
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      IconButton(icon: Icon(UniconsLine.home_alt, color: Colors.white, size: 30,), onPressed: () {},),
      IconButton(icon: Icon(UniconsLine.search, color: Colors.white , size: 30,), onPressed: () {},),
    IconButton(icon: Icon(UniconsLine.heart, color: Colors.white, size: 30), onPressed: () {},),
    IconButton(icon: Icon(UniconsLine.user, color: Colors.white, size: 30), onPressed: () {},),
    ],
    ),

      )

 */




          );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlicious_app/managers/post_manager.dart';
import 'package:famlicious_app/views/chat/chat_view.dart';
import 'package:famlicious_app/views/timeline/create_post_view.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:unicons/unicons.dart';

class TimelineView extends StatefulWidget {
  TimelineView({Key? key}) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  final PostManager _postManager = PostManager();
  bool flag=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        //title: const Text('Timeline' , style: TextStyle(fontSize: 20 , color: Colors.blueAccent),),
        title: Icon(UniconsLine.twitter ,size: 30 , color: Colors.blueAccent,),




        leading: IconButton(
            onPressed: () => null,
            icon: Icon(
                UniconsLine.user_circle,
                color: Theme.of(context).iconTheme.color,
                size: 30
            ))
          ,


        actions: [


          IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ChatScreen())),
              icon: Icon(
                UniconsLine.hipchat,
                color: Theme.of(context).iconTheme.color,
                  size: 30
              ))
          ,





        ],
      ),
      body:

      StreamBuilder<QuerySnapshot<Map<String, dynamic>?>>(
          stream: _postManager.getAllPosts(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10),

              scrollDirection: Axis.vertical,

              child: ListView.separated(





                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,


                  itemBuilder: (context, index) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.data == null) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data == null) {
                      return const Center(child: Text('No data available'));
                    }

                    return Card(

                     // style:Theme.of(context).textTheme.bodyText1!.copyWith(
                          //color: Theme.of(context).buttonTheme.colorScheme!.background),
                      elevation: 0,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      //color: Colors.black,
                      //margin: const EdgeInsets.all(0),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StreamBuilder<Map<String, dynamic>?>(
                                stream: _postManager
                                    .getUserInfo(snapshot.data!.docs[index]
                                        .data()!['user_uid'])
                                    .asStream(),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                          ConnectionState.waiting &&
                                      userSnapshot.data == null) {
                                    return const Center(
                                        child:
                                            LinearProgressIndicator());
                                  }

                                  if (userSnapshot.connectionState ==
                                          ConnectionState.done &&
                                      userSnapshot.data == null) {
                                    return const ListTile();
                                  }
                                  return ListTile(

                                    contentPadding: const EdgeInsets.all(0),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          userSnapshot.data!['picture']!),
                                    ),
                                    title: Text(userSnapshot.data!['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600)),
                                    subtitle: Text(
                                        timeago.format(
                                            snapshot.data!.docs[index]
                                                .data()!['createdAt']
                                                .toDate() ,
                                            allowFromNow: true),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                fontSize:12,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey)),

                                    trailing:

                                    AnimatedSwitcher(
                                      duration: const Duration(seconds:  0),


                                        transitionBuilder:(Widget child,
                                            Animation<double>animation)=>
                                      RotationTransition(child:child, turns: animation),


                                      child:

                                      flag ?
                                      FloatingActionButton.extended(
                                        key: Key('1'),
                                        label: const Text('Follow' , style: TextStyle(color: Colors.blueAccent , fontWeight: FontWeight.bold , fontSize: 15),), // <-- Text
                                        backgroundColor: Colors.white12,
                                        icon: const Icon( // <-- Icon
                                          Icons.notification_add,
                                          size: 20.0,
                                          color: Colors.blueAccent,

                                        ),


                                        onPressed: () {
                                          setState(() {

                                            flag=!flag;

                                          });

                                        },
                                      )
                                      :
                                      FloatingActionButton.extended(
                                        key: Key('2'),
                                        label: const Text('Following' , style: TextStyle(color: Colors.redAccent , fontWeight: FontWeight.bold , fontSize: 15),), // <-- Text
                                        backgroundColor: Colors.white12,
                                        icon: const Icon( // <-- Icon
                                          Icons.notification_add,
                                          size: 20.0,
                                          color: Colors.red,

                                        ),

                                        onPressed: () {
                                          setState(() {
                                            flag=!flag;

                                          });

                                        },
                                      ),




                                    ),
                                  );
                                }),

                            const SizedBox(height: 12),

                            snapshot.data!.docs[index]
                                    .data()!['description']!
                                    .isEmpty
                                ? const SizedBox.shrink()
                                : Row(
                                  children: [
                                    const Text('  '),
                                    Flexible(
                                      child: Text(
                                          snapshot.data!.docs[index]
                                              .data()!['description']!,
                                          textAlign: TextAlign.left,
                                        ),
                                    ),
                                  ],
                                ),

                            const SizedBox(height: 12),



                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                snapshot.data!.docs[index].data()!['image_url']!,
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: null,
                                        icon: Icon(UniconsLine.thumbs_up,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color)),
                                    IconButton(
                                        onPressed: null,
                                        icon: Icon(UniconsLine.comment_lines,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color))
                                  ],
                                ),
                                IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      UniconsLine.telegram_alt,
                                      color: Theme.of(context).iconTheme.color,
                                    ))
                              ],
                            ),
/*
                            snapshot.data!.docs[index]
                                .data()!['description']!
                                .isEmpty
                                ? const SizedBox.shrink()
                                : Text(
                              snapshot.data!.docs[index]
                                  .data()!['description']!,
                              textAlign: TextAlign.end,
                            ),

 */
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length),
            );
          }),


      floatingActionButton: FloatingActionButton(

        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreatePostView()));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(UniconsLine.plus , size: 20, color: Colors.white,),
      ),











    );
  }
}



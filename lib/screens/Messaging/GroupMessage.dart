import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/screens/Homepage/Homepage.dart';
import 'package:thesocial1/screens/Messaging/GroupMessagingHelpers.dart';
import 'package:thesocial1/services/Authentication.dart';
import '../../constants/Constantcolors.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  GroupMessage({required this.documentSnapshot});

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    Provider.of<GroupMessagingHelpers>(context, listen: false)
        .checkIfJoined(context, widget.documentSnapshot.id,
            widget.documentSnapshot['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessagingHelpers>(context, listen: false)
              .getHasMemberJoined ==
          false) {
        Timer(
            Duration(milliseconds: 10),
            () => Provider.of<GroupMessagingHelpers>(context, listen: false)
                .askToJoin(context, widget.documentSnapshot.id));
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        actions: [
          Provider.of<Authentication>(context, listen: false).getUserUid ==
                  widget.documentSnapshot['useruid']
              ? IconButton(
                  onPressed: () {},
                  icon: Icon(EvaIcons.moreVertical,
                      color: constantColors.whiteColor))
              : Container(
                  height: 0.0,
                  width: 0.0,
                ),
          IconButton(
            onPressed: () {
              Provider.of<GroupMessagingHelpers>(context, listen: false)
                  .leaveTheRoom(context, widget.documentSnapshot.id);
            },
            icon: Icon(EvaIcons.logOutOutline),
            color: constantColors.redColor,
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Homepage(), type: PageTransitionType.leftToRight));
          },
        ),
        backgroundColor: constantColors.darkColor,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                backgroundImage:
                    NetworkImage(widget.documentSnapshot['roomavatar']),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.documentSnapshot['roomname'],
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(widget.documentSnapshot.id)
                          .collection('members')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return new Text(
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: constantColors.greenColor),
                              '${snapshot.data!.docs.length.toString()} members');
                        }
                      })
                ],
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                child:
                    Provider.of<GroupMessagingHelpers>(context, listen: false)
                        .showMessages(context, widget.documentSnapshot,
                            widget.documentSnapshot['useruid']),
                color: constantColors.darkColor,
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: constantColors.blueGreyColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<GroupMessagingHelpers>(context,
                                  listen: false)
                              .showSticker(context, widget.documentSnapshot.id);
                        },
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: constantColors.transperant,
                          backgroundImage:
                              AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: constantColors.greenColor),
                            decoration: InputDecoration(
                              hintText: 'Drop a hi...',
                              hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: constantColors.greenColor),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            Provider.of<GroupMessagingHelpers>(context,
                                    listen: false)
                                .sendMessage(context, widget.documentSnapshot,
                                    messageController);
                          }
                        },
                        child: Icon(Icons.send_sharp,
                            color: constantColors.whiteColor),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

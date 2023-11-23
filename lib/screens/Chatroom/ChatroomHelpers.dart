import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/screens/AltProfile/alt_profile.dart';
import 'package:thesocial1/screens/Messaging/GroupMessage.dart';
import 'package:thesocial1/services/Authentication.dart';
import 'package:thesocial1/services/FirebaseOperations.dart';
import '../../constants/Constantcolors.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelpers with ChangeNotifier {
  late String latestMessageTime;

  String get getLatesteMessageTime => latestMessageTime;
  late String chatroomAvatarUrl = '', chatroomId;

  String get getChatroomId => chatroomId;

  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  ConstantColors constantColors = ConstantColors();
  final TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  color: constantColors.whiteColor,
                  thickness: 4.0,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.blueColor),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Members',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Center(child: CircularProgressIndicator());
                      } else {
                        return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid !=
                                        documentSnapshot['useruid']) {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: AltProfile(
                                                userUid:
                                                    documentSnapshot['useruid'],
                                              ),
                                              type: PageTransitionType
                                                  .bottomToTop));
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: constantColors.darkColor,
                                    backgroundImage: NetworkImage(
                                        documentSnapshot['userimage']),
                                  ),
                                ),
                              );
                            }).toList());
                      }
                    }),
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.yellowColor),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: constantColors.transperant,
                      backgroundImage:
                          NetworkImage(documentSnapshot['userimage']),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            documentSnapshot['username'],
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Provider.of<Authentication>(context, listen: false)
                                    .getUserUid ==
                                documentSnapshot['useruid']
                            ? Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: MaterialButton(
                                    color: constantColors.redColor,
                                    child: Text('Delete Room',
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0)),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                'Are you sure?',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor),
                                              ),
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              actions: [
                                                MaterialButton(
                                                    child: Text('No',
                                                        style: TextStyle(
                                                            color:
                                                                constantColors
                                                                    .whiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16.0)),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                MaterialButton(
                                                    color:
                                                        constantColors.redColor,
                                                    child: Text('Yes',
                                                        style: TextStyle(
                                                            color:
                                                                constantColors
                                                                    .whiteColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16.0)),
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'chatrooms')
                                                          .doc(documentSnapshot
                                                              .id)
                                                          .delete();
                                                    })
                                              ],
                                            );
                                          });
                                    }),
                              )
                            : Container(
                                width: 0.0,
                                height: 0.0,
                              )
                      ],
                    )
                  ],
                ),
              )
            ]),
          );
        });
  }

  showCreateChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4.0,
                    ),
                  ),
                  Text(
                    'Select Chatroom Avatar',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomIcons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return GestureDetector(
                                  onTap: () {
                                    chatroomAvatarUrl =
                                        documentSnapshot['image'];
                                    print(chatroomAvatarUrl);
                                    notifyListeners();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: chatroomAvatarUrl ==
                                                      documentSnapshot['image']
                                                  ? constantColors.blueColor
                                                  : constantColors
                                                      .transperant)),
                                      height: 10.0,
                                      width: 40.0,
                                      child: Image.network(
                                          documentSnapshot['image']),
                                    ),
                                  ),
                                );
                              }).toList());
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatroomNameController,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                          decoration: InputDecoration(
                              hintText: 'Enter chatroom Id',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0)),
                        ),
                      ),
                      FloatingActionButton(
                          backgroundColor: constantColors.blueGreyColor,
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: constantColors.yellowColor,
                          ),
                          onPressed: () async {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .submitChatroomData(
                                    chatroomNameController.text, {
                              'roomavatar': getChatroomAvatarUrl,
                              'time': Timestamp.now(),
                              'roomname': chatroomNameController.text,
                              'username': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'userimage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'useremail': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                            }).whenComplete(() {
                              Navigator.pop(context);
                            });
                          })
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      topLeft: Radius.circular(12.0))),
            ),
          );
        });
  }

  showChatrooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: Lottie.asset('assets/animations/loading.json'),
              ),
            );
          } else {
            return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child:
                              GroupMessage(documentSnapshot: documentSnapshot),
                          type: PageTransitionType.leftToRight));
                },
                onLongPress: () {
                  showChatroomDetails(context, documentSnapshot);
                },
                trailing: Container(
                  width: 80.0,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      showLastMessageTime(snapshot.data!.docs.first['time']);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Text(
                          getLatesteMessageTime,
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                ),
                title: Text(documentSnapshot['roomname'],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold)),
                subtitle: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(documentSnapshot.id)
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data!.docs.first['username'] != null &&
                        snapshot.data!.docs.first['message'] != '') {
                      return Text(
                        ('${snapshot.data!.docs.first['username']} : ${snapshot.data!.docs.first['message']}'),
                        style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      );
                    } else if (snapshot.data!.docs.first['username'] != null &&
                        snapshot.data!.docs.first['sticker'] != null) {
                      return Text(
                        '${snapshot.data!.docs.first['username']} : Sticker ',
                        style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold),
                      );
                    } else {
                      return Container(width: 0.0, height: 0.0);
                    }
                  },
                ),
                leading: CircleAvatar(
                  backgroundColor: constantColors.transperant,
                  backgroundImage: NetworkImage(documentSnapshot['roomavatar']),
                ),
              );
            }).toList());
          }
        });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    notifyListeners();
  }
}

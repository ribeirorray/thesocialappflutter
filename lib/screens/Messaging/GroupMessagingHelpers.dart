import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/screens/Homepage/Homepage.dart';
import 'package:thesocial1/services/Authentication.dart';
import '../../constants/Constantcolors.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../services/FirebaseOperations.dart';

class GroupMessagingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  bool hasMemberJoined = false;

  bool get getHasMemberJoined => hasMemberJoined;
  late String lastMessageTime;

  String get getLasMessageTime => lastMessageTime;

  leaveTheRoom(BuildContext context, String chatRoomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text('Leave $chatRoomName ?',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 18.0,

                    fontWeight: FontWeight.bold)),
            actions: [
              MaterialButton(
                  child: Text('No',
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(color: constantColors.redColor,
                  child: Text('Yes',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(chatRoomName)
                        .collection('members')
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .delete()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: Homepage(),
                              type: PageTransitionType.bottomToTop));
                    });
                  })
            ],
          );
        });
  }

  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(documentSnapshot.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
                reverse: true,
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  showLastMessageTime(documentSnapshot['time']);
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                        height: documentSnapshot['message'] != ''
                            ? MediaQuery.of(context).size.height * 0.125
                            : MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 60.0, top: 20.0),
                              child: Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          documentSnapshot['message'] == null
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.42,
                                      maxWidth: documentSnapshot['sticker'] !=
                                              null
                                          ? MediaQuery.of(context).size.height *
                                              0.8
                                          : MediaQuery.of(context).size.height *
                                              0.9,
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 18.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 150.0,
                                            child: Row(
                                              children: [
                                                Text(
                                                  documentSnapshot['username'],
                                                  style: TextStyle(
                                                      color: constantColors
                                                          .greenColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0),
                                                ),
                                                Provider.of<Authentication>(
                                                                context,
                                                                listen: false)
                                                            .getUserUid ==
                                                        adminUserUid
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .chessKing,
                                                          color: constantColors
                                                              .yellowColor,
                                                          size: 12.0,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 0.0,
                                                        height: 0.0,
                                                      )
                                              ],
                                            ),
                                          ),
                                          documentSnapshot['message'] != ''
                                              ? Text(
                                                  documentSnapshot['message'],
                                                  style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontSize: 14.0))
                                              : Container(
                                                  color: constantColors
                                                      .blueGreyColor,
                                                  height: 90.0,
                                                  width: 100.0,
                                                  child: Image.network(
                                                      documentSnapshot[
                                                          'sticker']),
                                                ),
                                          Container(
                                            width: 80.0,
                                            child: Text(
                                              getLasMessageTime,
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 8.0),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Provider.of<Authentication>(
                                                        context,
                                                        listen: false)
                                                    .getUserUid ==
                                                documentSnapshot['useruid']
                                            ? constantColors.blueGreyColor
                                                .withOpacity(0.8)
                                            : constantColors.blueGreyColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              child: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot['useruid']
                                  ? Container(
                                      child: Container(
                                      child: Column(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.edit,
                                                color: constantColors.blueColor,
                                                size: 18.0,
                                              )),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                FontAwesomeIcons.trash,
                                                color: constantColors.redColor,
                                                size: 18.0,
                                              ))
                                        ],
                                      ),
                                    ))
                                  : Container(
                                      height: 0.0,
                                      width: 0.0,
                                    ),
                            ),
                            Positioned(
                                left: 40,
                                child: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid ==
                                        documentSnapshot['useruid']
                                    ? Container(
                                        height: 0.0,
                                        width: 0.0,
                                      )
                                    : CircleAvatar(
                                        backgroundColor:
                                            constantColors.darkColor,
                                        backgroundImage: NetworkImage(
                                            documentSnapshot['userimage']),
                                      ))
                          ],
                        )),
                  );
                }).toList());
          }
        });
  }

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'sticker': '',
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
    }).whenComplete(() {
      messageController.text='';
    });
  }

  Future checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      print('Initial State => $hasMemberJoined');
      if (value['joined'] != null) {
        hasMemberJoined = value['joined'];
        print('Final State => $hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text('Join $roomName?',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            actions: [
              MaterialButton(
                  child: Text('No',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: Homepage(),
                            type: PageTransitionType.bottomToTop));
                  }),
              MaterialButton(
                  color: constantColors.blueColor,
                  child: Text('Yes',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(roomName)
                        .collection('members')
                        .doc(Provider.of<Authentication>(context, listen: false)
                            .getUserUid)
                        .set({
                      'joined': true,
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserImage,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now()
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  })
            ],
          );
        });
  }

  showSticker(BuildContext context, String chatroomid) {
    return showModalBottomSheet(
        backgroundColor: constantColors.darkColor,
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 105.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border:
                                  Border.all(color: constantColors.blueColor)),
                          height: 30.0,
                          width: 30.0,
                          child: Image.asset('assets/icons/sunflower.png'),
                        ),
                      ],
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stickers')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Center(child: CircularProgressIndicator());
                      } else {
                        return new GridView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  sendStickers(context,
                                      documentSnapshot['image'], chatroomid);
                                },
                                child: Container(
                                  height: 40.0,
                                  width: 40.0,
                                  child:
                                      Image.network(documentSnapshot['image']),
                                ),
                              );
                            }).toList(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3));
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  sendStickers(
      BuildContext context, String stickerImageUrl, String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'message': '',
      'sticker': stickerImageUrl,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'time': Timestamp.now()
    });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
  }
}

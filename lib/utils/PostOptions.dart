import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/constants/Constantcolors.dart';
import 'package:thesocial1/screens/AltProfile/alt_profile.dart';
import 'package:thesocial1/screens/LandingPage/landingServices.dart';
import 'package:thesocial1/services/Authentication.dart';
import 'package:thesocial1/services/FirebaseOperations.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  TextEditingController updatedCaptionController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  late String imageTimePosted;

  String get getImageTimePosted => imageTimePosted;

  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }

  showPostOptions(BuildContext context, String postId) {
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
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                            color: constantColors.blueColor,
                            child: Text(
                              'Edit caption',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 300.0,
                                              height: 50.0,
                                              child: TextField(

                                                decoration: InputDecoration(
                                                    hintText: 'Add new Caption',
                                                    hintStyle: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                                controller:
                                                    updatedCaptionController,
                                              ),
                                            ),
                                            FloatingActionButton(
                                                backgroundColor:
                                                    constantColors.redColor,
                                                child: Icon(
                                                  FontAwesomeIcons.upload,
                                                  color:
                                                      constantColors.whiteColor,
                                                ),
                                                onPressed: () {
                                                  Provider.of<FirebaseOperations>(
                                                          context,
                                                          listen: false)
                                                      .updateCaption(postId, {
                                                    'caption':
                                                        updatedCaptionController
                                                            .text
                                                  }).whenComplete(() {
                                                    updatedCaptionController.text='';

                                                  });
                                                })
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }),
                        MaterialButton(
                            color: constantColors.redColor,
                            child: Text(
                              'Delete Post',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: constantColors.darkColor,
                                      title: Text('Delete this post?',
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      actions: [
                                        MaterialButton(
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      constantColors.whiteColor,
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                        MaterialButton(
                                            color: constantColors.redColor,
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            onPressed: () {
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .deleteUserData(
                                                      postId, 'posts')
                                                  .whenComplete(() {
                                                Navigator.pop(context);
                                              });
                                            }),
                                      ],
                                    );
                                  });
                            })
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
          );
        });
  }

//subcollections do post

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(String postId, String comment, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                        thickness: 4.0,
                        color: constantColors.whiteColor,
                      ),
                    ),
                    Container(
                      width: 100.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: constantColors.whiteColor),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Center(
                        child: Text('Comments',
                            style: TextStyle(
                                color: constantColors.blueColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.63,
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(docId)
                              .collection('comments')
                              .orderBy('time')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return new ListView(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot documentSnapshot) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: AltProfile(
                                                        userUid:
                                                            documentSnapshot[
                                                                'useruid'],
                                                      ),
                                                      type: PageTransitionType
                                                          .bottomToTop));
                                            },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  constantColors.darkColor,
                                              radius: 15.0,
                                              backgroundImage: NetworkImage(
                                                  documentSnapshot[
                                                      'userimage']),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      documentSnapshot[
                                                          'username'],
                                                      style: TextStyle(
                                                          color: constantColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          FontAwesomeIcons
                                                              .arrowUp,
                                                          color: constantColors
                                                              .blueColor,
                                                          size: 12.0,
                                                        )),
                                                    Row(
                                                      children: [
                                                        Text('0',
                                                            style: TextStyle(
                                                                color: constantColors
                                                                    .whiteColor,
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              FontAwesomeIcons
                                                                  .reply,
                                                              color: constantColors
                                                                  .yellowColor,
                                                              size: 13.0,
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                icon: Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
                                                    color: constantColors
                                                        .blueColor,
                                                    size: 13.0),
                                                onPressed: () {}),
                                            Container(
                                              width: 270.0,
                                              child: Text(
                                                  documentSnapshot['comment'],
                                                  style: TextStyle(
                                                      color: constantColors
                                                          .whiteColor,
                                                      fontSize: 16.0)),
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  FontAwesomeIcons.trash,
                                                  color:
                                                      constantColors.redColor,
                                                  size: 19.0,
                                                )),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: constantColors.darkColor
                                            .withOpacity(0.2),
                                      )
                                    ],
                                  ),
                                );
                              }).toList());
                            }
                          },
                        )),
                    Container(
                      width: 400.0,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 300.0,
                            height: 30.0,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: 'Add Comment',
                                hintStyle: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              controller: commentController,
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FloatingActionButton(
                              onPressed: () {
                                print('Adding a comment');
                                addComment(snapshot['caption'],
                                        commentController.text, context)
                                    .whenComplete(() {
                                  commentController.clear();
                                  notifyListeners();
                                });
                              },
                              backgroundColor: constantColors.greenColor,
                              child: Icon(
                                FontAwesomeIcons.comment,
                                color: constantColors.whiteColor,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: constantColors.blueGreyColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0)))),
          );
        });
  }

  showAwardsPresenter(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 200.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text('Awards Socialites',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.63,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('awards')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return new ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid:
                                            documentSnapshot['useruid'],
                                          ),
                                          type:
                                          PageTransitionType.bottomToTop));
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['userimage']),
                                  radius: 15.0,
                                  backgroundColor: constantColors.darkColor,
                                ),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot['useruid']
                                  ? Container(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : MaterialButton(
                                color: constantColors.blueColor,
                                      onPressed: () {},
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                    ),
                              title: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList());
                        }
                      },
                    ))
              ],
            ),
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text('Likes',
                          style: TextStyle(
                              color: constantColors.blueColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                    height: 100.0,
                    width: 400.0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .collection('likes')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return new ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid:
                                                documentSnapshot['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['userimage']),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Text(
                                documentSnapshot['useremail'],
                                style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot['useruid']
                                  ? Container(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : MaterialButton(
                                      onPressed: () {},
                                      color: constantColors.blueColor,
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                            );
                          }).toList());
                        }
                      },
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  )));
        });
  }

  showRewards(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                    child: Text('Rewards',
                        style: TextStyle(
                            color: constantColors.blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('awards')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return GestureDetector(
                                  onTap: () async {
                                    print(documentSnapshot['image']);
                                    await Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .addAward(postId, {
                                      'username':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserName,
                                      'userimage':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getInitUserImage,
                                      'useruid': Provider.of<Authentication>(
                                              context,
                                              listen: false)
                                          .getUserUid,
                                      'time': Timestamp.now(),
                                      'award': documentSnapshot['image']
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(
                                      height: 80.0,
                                      width: 50.0,
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
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0))),
          );
        });
  }
}

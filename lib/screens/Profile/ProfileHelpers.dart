import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/constants/Constantcolors.dart';
import 'package:thesocial1/screens/AltProfile/alt_profile.dart';
import 'package:thesocial1/screens/LandingPage/landingPage.dart';
import 'package:thesocial1/screens/Stories/Stories_widgets.dart';
import 'package:thesocial1/services/Authentication.dart';

import '../../utils/PostOptions.dart';

class ProfileHelpers with ChangeNotifier {
  final StorieWidgets storieWidgets = StorieWidgets();
  ConstantColors constantColors = ConstantColors();

  Widget headerProfile(BuildContext context, DocumentSnapshot snapshot) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 220.0,
            width: 180.0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    storieWidgets.addStory(context);
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: constantColors.transperant,
                        radius: 60.0,
                        backgroundImage: NetworkImage(snapshot['userimage']),
                      ),
                      Positioned(
                          top: 90.0,
                          left: 90.0,
                          child: Icon(EvaIcons.plusCircle,color: constantColors.whiteColor,size: 33.0,))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    snapshot['username'],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          snapshot['useremail'],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0),
                        ),

                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
          Container(
            width: 170.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          checkFollowersSheet(context, snapshot);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: 70.0,
                          width: 80.0,
                          child: Column(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot['useruid'])
                                      .collection('followers')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return new Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26));
                                    }
                                  }),
                              Text(
                                'Followers',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkFollowingSheet(context, snapshot);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: constantColors.darkColor,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: 70.0,
                          width: 80.0,
                          child: Column(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot['useruid'])
                                      .collection('following')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return new Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26));
                                    }
                                  }),
                              Text('Following',
                                  style: TextStyle(
                                      color: constantColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.8))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: constantColors.darkColor,
                        borderRadius: BorderRadius.circular(15.0)),
                    height: 70.0,
                    width: 80.0,
                    child: Column(
                      children: [
                        Text(
                          '0',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.8),
                        ),
                        Text('Posts',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget middleProfile(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      FontAwesomeIcons.userAstronaut,
                      color: constantColors.yellowColor,
                      size: 16,
                    ),
                    Text(
                      'Recently Added',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: constantColors.whiteColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(documentSnapshot['useruid'])
                          .collection('following')
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
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return new Container(
                                    height: 60.0,
                                    width: 60.0,
                                    child: CircleAvatar(
                                      backgroundColor: constantColors.darkColor,
                                      backgroundImage: NetworkImage(
                                          documentSnapshot['userimage']),
                                    ),
                                  );
                                }
                              }).toList());
                        }
                      }),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: constantColors.darkColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
                .collection('posts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return new GridView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      return GestureDetector(
                        onTap: () {
                          showPostDetails(context, documentSnapshot);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: constantColors.transperant,
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              child:
                                  Image.network(documentSnapshot['postimage']),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2));
              }
            }),
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constantColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text('Log Out?',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: constantColors.redColor,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 18.0,
                        decoration: TextDecoration.underline,
                        decorationColor: constantColors.whiteColor),
                  ),
                  onPressed: () {
                    Provider.of<Authentication>(context, listen: false)
                        .logOutViaEmail()
                        .whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: LandingPage(),
                              type: PageTransitionType.bottomToTop));
                    });
                  })
            ],
          );
        });
  }

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot['useruid'])
                    .collection('following')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return new ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListTile(
                          onTap: () {
                            if (documentSnapshot['useruid'] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid) {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: AltProfile(
                                        userUid: documentSnapshot['useruid'],
                                      ),
                                      type: PageTransitionType.leftToRight));
                            }
                          },
                          trailing: documentSnapshot['useruid'] ==
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid
                              ? Container(
                                  height: 0.0,
                                  width: 0.0,
                                )
                              : MaterialButton(
                                  color: constantColors.blueColor,
                                  child: Text('Unfollow',
                                      style: TextStyle(
                                          color: constantColors.whiteColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {},
                                ),
                          leading: CircleAvatar(
                            backgroundColor: constantColors.darkColor,
                            backgroundImage:
                                NetworkImage(documentSnapshot['userimage']),
                          ),
                          title: Text(
                            documentSnapshot['username'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          subtitle: Text(
                            documentSnapshot['useremail'],
                            style: TextStyle(
                                color: constantColors.yellowColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        );
                      }
                    }).toList());
                  }
                }),
          );
        });
  }

  checkFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0)),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot['useruid'])
                    .collection('followers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return new ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListTile(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                      userUid: documentSnapshot['useruid'],
                                    ),
                                    type: PageTransitionType.topToBottom));
                          },
                          trailing: MaterialButton(
                            color: constantColors.blueColor,
                            child: Text('Unfollow',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {},
                          ),
                          leading: CircleAvatar(
                            backgroundColor: constantColors.darkColor,
                            backgroundImage:
                                NetworkImage(documentSnapshot['userimage']),
                          ),
                          title: Text(
                            documentSnapshot['username'],
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          subtitle: Text(
                            documentSnapshot['useremail'],
                            style: TextStyle(
                                color: constantColors.yellowColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        );
                      }
                    }).toList());
                  }
                }),
          );
        });
  }

  showPostDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: Image.network(documentSnapshot['postimage']),
                    )),
                Text(documentSnapshot['caption'],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: 80.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showLikes(
                                          context, documentSnapshot['caption']);
                                },
                                onTap: () {
                                  print('Adding like...');
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .addLike(
                                          context,
                                          documentSnapshot['caption'],
                                          Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserUid);
                                },
                                child: Icon(
                                  FontAwesomeIcons.heart,
                                  color: constantColors.redColor,
                                  size: 22.0,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(documentSnapshot['caption'])
                                      .collection('likes')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          )),
                      Container(
                          width: 80.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showCommentsSheet(
                                          context,
                                          documentSnapshot,
                                          documentSnapshot['caption']);
                                },
                                child: Icon(
                                  FontAwesomeIcons.comment,
                                  color: constantColors.blueColor,
                                  size: 22.0,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(documentSnapshot['caption'])
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      );
                                    }
                                  }),
                            ],
                          )),
                      Container(
                          width: 80.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showAwardsPresenter(
                                          context, documentSnapshot['caption']);
                                },
                                onTap: () {
                                  Provider.of<PostFunctions>(context,
                                          listen: false)
                                      .showRewards(
                                          context, documentSnapshot['caption']);
                                },
                                child: Icon(
                                  FontAwesomeIcons.award,
                                  color: constantColors.yellowColor,
                                  size: 22.0,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(documentSnapshot['caption'])
                                      .collection('awards')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      );
                                    }
                                  })
                            ],
                          )),
                      Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              documentSnapshot['useruid']
                          ? IconButton(
                              icon: Icon(EvaIcons.moreVertical,
                                  color: constantColors.whiteColor),
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptions(
                                        context, documentSnapshot['caption']);
                              })
                          : Container(
                              width: 0.0,
                              height: 0.0,
                            )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

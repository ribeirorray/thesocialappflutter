import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/screens/Homepage/Homepage.dart';
import 'package:thesocial1/screens/Stories/Stories_Helpers.dart';
import 'package:thesocial1/services/Authentication.dart';
import 'package:thesocial1/services/FirebaseOperations.dart';

import '../../constants/Constantcolors.dart';

class StorieWidgets {
  ConstantColors constantColors = ConstantColors();

  addStory(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () {
                        Provider.of<StoriesHelper>(context, listen: false)
                            .selectStoryImage(context, ImageSource.gallery)
                            .whenComplete(() {});
                      },
                      child: Text('Gallery',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      onPressed: () {
                        Provider.of<StoriesHelper>(context, listen: false)
                            .selectStoryImage(context, ImageSource.camera)
                            .whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Text('Camera',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                    )
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  previewStoryImage(BuildContext context, File storyImage) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: constantColors.darkColor),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(storyImage),
                ),
                Positioned(
                    top: 700.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                              heroTag: 'Reselect image',
                              backgroundColor: constantColors.redColor,
                              child: Icon(FontAwesomeIcons.backwardStep,
                                  color: constantColors.whiteColor),
                              onPressed: () {
                                addStory(context);
                              }),
                          FloatingActionButton(
                              heroTag: 'Confirm image',
                              backgroundColor: constantColors.blueColor,
                              child: Icon(FontAwesomeIcons.check,
                                  color: constantColors.whiteColor),
                              onPressed: () {
                                Provider.of<StoriesHelper>(context,
                                        listen: false)
                                    .uploadStoryImage(context)
                                    .whenComplete(() async {
                                  try {
                                    if (Provider.of<StoriesHelper>(context,
                                                listen: false)
                                            .getStoryImageUrl !=
                                        null) {
                                      await FirebaseFirestore.instance
                                          .collection('stories')
                                          .doc(Provider.of<Authentication>(
                                                  context,
                                                  listen: false)
                                              .getUserUid)
                                          .set({
                                        'image': Provider.of<StoriesHelper>(
                                                context,
                                                listen: false)
                                            .getStoryImageUrl,
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
                                        'time': Timestamp.now(),
                                        'useruid': Provider.of<Authentication>(
                                                context,
                                                listen: false)
                                            .getUserUid,
                                      }).whenComplete(() {
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: Homepage(),
                                                type: PageTransitionType
                                                    .bottomToTop));
                                      });
                                    } else {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      constantColors.darkColor),
                                              child: Center(
                                                child: MaterialButton(
                                                  child: Text(
                                                    'Upload Story!',
                                                    style: TextStyle(
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16.0),
                                                  ),
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('stories')
                                                        .doc(Provider.of<
                                                                    Authentication>(
                                                                context,
                                                                listen: false)
                                                            .getUserUid)
                                                        .set({
                                                      'image': Provider.of<
                                                                  StoriesHelper>(
                                                              context,
                                                              listen: false)
                                                          .getStoryImageUrl,
                                                      'username': Provider.of<
                                                                  FirebaseOperations>(
                                                              context,
                                                              listen: false)
                                                          .getInitUserName,
                                                      'userimage': Provider.of<
                                                                  FirebaseOperations>(
                                                              context,
                                                              listen: false)
                                                          .getInitUserImage,
                                                      'time': Timestamp.now(),
                                                      'useruid': Provider.of<
                                                                  Authentication>(
                                                              context,
                                                              listen: false)
                                                          .getUserUid,
                                                    }).whenComplete(() {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          PageTransition(
                                                              child: Homepage(),
                                                              type: PageTransitionType
                                                                  .bottomToTop));
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                });
                              })
                        ],
                      ),
                    ))
              ],
            ),
          );
        });
  }
}

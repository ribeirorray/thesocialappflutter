import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/screens/LandingPage/landingUtils.dart';
import 'package:thesocial1/services/Authentication.dart';

class FirebaseOperations with ChangeNotifier {
  late UploadTask imageUploadTask;
  late String initUserEmail;
  late String initUserName;
  late String initUserImage = '';

  String get getInitUserImage => initUserImage;

  String get getInitUserName => initUserName;

  String get getInitUserEmail => initUserEmail;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar.path}/${TimeOfDay.now()}');
    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      print('Image Uploaded!');
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl =
          url.toString();
      print(
          'The user profile avatar url => ${Provider.of<LandingUtils>(context, listen: false).userAvatar.path}');
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('Fetching user data');
      initUserName = doc['username'];
      initUserEmail = doc['useremail'];
      initUserImage = doc['userimage'];
      print(initUserName);
      print(initUserEmail);
      print(initUserImage);
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userUid, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  Future updateCaption(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future addAward(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('awards')
        .add(data);
  }

  Future followUser(
      //tuturial 9  10:00 explicação
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future submitChatroomData(
      String chatRoomName, dynamic chatRoomData) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .set(chatRoomData);
  }
}

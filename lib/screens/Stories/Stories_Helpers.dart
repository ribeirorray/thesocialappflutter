import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'Stories_widgets.dart';

class StoriesHelper with ChangeNotifier {
  late File storyImage;
  final picker = ImagePicker();
  late UploadTask imageUploadTask;

  File get getStoryImage => storyImage;
  final StorieWidgets storieWidgets = StorieWidgets();
  late String storyImageUrl='';

  String get getStoryImageUrl => storyImageUrl;

  Future selectStoryImage(BuildContext context, ImageSource source) async {
    final pickedStoryImage = await picker.pickImage(source: source);
    pickedStoryImage == null
        ? print('Error')
        : storyImage = File(pickedStoryImage.path);
    storyImage != null
        ? storieWidgets.previewStoryImage(context, storyImage)
        : print('Error');
    notifyListeners();
  }

  Future uploadStoryImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage.path}/${Timestamp.now()}');
    imageUploadTask = imageReference.putFile(getStoryImage);
    await imageUploadTask.whenComplete(() {
      print('Story image uploaded');
    });
    imageReference.getDownloadURL().then((url) {
      storyImageUrl = url;
      print(storyImageUrl);
    });
    notifyListeners();
  }

}

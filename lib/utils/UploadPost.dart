import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/constants/Constantcolors.dart';
import 'package:thesocial1/screens/Homepage/Homepage.dart';
import 'package:thesocial1/services/Authentication.dart';
import 'package:thesocial1/services/FirebaseOperations.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  late File uploadPostImage;

  File get getUploadPostImage => uploadPostImage;
  late String uploadPostImageUrl;

  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  late UploadTask imagePostUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? print('Select Image')
        : uploadPostImage = File(uploadPostImageVal.path);
    print(uploadPostImageVal?.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print('Image upload error');
    notifyListeners();
  }

  Future uploadPostImageToFireBase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {
      print('Post image upload to storage ');
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12)),
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
                        child: Text(
                          'Gallery',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.gallery);
                        }),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Camera',
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.camera);
                        })
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.38,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Container(
                    height: 200.0,
                    width: 400.0,
                    child: Image.file(
                      uploadPostImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          child: Text('Reselect',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: constantColors.whiteColor)),
                          onPressed: () {
                            selectPostImageType(context);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text('Confirme a imagem',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  decorationColor: constantColors.whiteColor)),
                          onPressed: () {
                            uploadPostImageToFireBase().whenComplete((){
                              editPostSheet(context);
                              print('Image uploaded');
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
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
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.image_aspect_ratio,
                                  color: constantColors.greenColor,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.fit_screen,
                                  color: constantColors.yellowColor,
                                ))
                          ],
                        ),
                      ),
                      Container(
                        height: 200.0,
                        width: 300.0,
                        child: Image.file(
                          uploadPostImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        height: 110.0,
                        width: 5.0,
                        color: constantColors.redColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 120.0,
                          width: 330.0,
                          child: TextField(
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLength: 100,
                            controller: captionController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Add a caption...',
                              hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  child: Text(
                    'Share',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  onPressed: () async {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .uploadPostData(captionController.text, {
                      'postimage': getUploadPostImageUrl,
                      'caption': captionController.text,
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserImage,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'time': Timestamp.now(),
                      'useremail': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserEmail,
                    }).whenComplete(() async {

                      // add data user profile
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('posts')
                          .add({
                        'caption': captionController.text,
                        'postimage': getUploadPostImageUrl,
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserName,
                        'userimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now(),
                        'useremail': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserEmail,

                      });
                    }).whenComplete(() {
                      captionController.text='';
                   Navigator.pushReplacement(context, PageTransition(child: Homepage(), type: PageTransitionType.bottomToTop));

                    });
                  },
                  color: constantColors.blueColor,
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
          );
        });
  }
}

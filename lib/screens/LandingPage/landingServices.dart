import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/constants/Constantcolors.dart';
import 'package:thesocial1/screens/Homepage/Homepage.dart';
import 'package:thesocial1/screens/LandingPage/landingUtils.dart';
import 'package:thesocial1/services/Authentication.dart';
import 'package:thesocial1/services/FirebaseOperations.dart';
import 'package:thesocial1/screens/SplashScreen/Splashscreen.dart';



class LandingService with ChangeNotifier {
  TextEditingController useremailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  ConstantColors constantColors = ConstantColors();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                    radius: 80.0,
                    backgroundColor: constantColors.transperant,
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .userAvatar)),
                Container(
                  child: Row(
                    children: [
                      MaterialButton(
                          child: Text('Reselect',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: constantColors.whiteColor)),
                          onPressed: () {
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserAvatar(context, ImageSource.gallery);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text('Confirme a imagem',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  decorationColor: constantColors.whiteColor)),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .uploadUserAvatar(context)
                                .whenComplete(() {
                              signInSheet(context);
                            });
                          })
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return new ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  trailing: Container(
                    width: 120.0,
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(FontAwesomeIcons.check,
                              color: constantColors.blueColor),
                          onPressed: () {
                            Provider.of<Authentication>(context, listen: false)
                                .logIntoAccount(documentSnapshot['useremail'],
                                    documentSnapshot['userpassword'])
                                .whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: Homepage(),
                                      type: PageTransitionType.leftToRight));
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.trash,
                              color: constantColors.redColor),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .deleteUserData(
                                    documentSnapshot['useruid'], 'users');
                          },
                        ),
                      ],
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: constantColors.darkColor,
                    backgroundImage:
                        NetworkImage(documentSnapshot['userimage']),
                  ),
                  subtitle: Text(
                    documentSnapshot['useremail'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                        fontSize: 12.0),
                  ),
                  title: Text(
                    documentSnapshot['username'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: constantColors.greenColor),
                  ),
                );
              }).toList());
            }
          },
        ));
  }

  logInSheet(BuildContext context) {
    bool passwordVisible=true;

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: useremailController,
                      decoration: InputDecoration(
                        icon: Icon(EvaIcons.email,
                            color: constantColors.blueColor),
                        hintText: 'Enter email...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),


                 Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(FontAwesomeIcons.check,
                            color: constantColors.whiteColor),
                        onPressed: () {
                          if (useremailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .logIntoAccount(useremailController.text,
                                    userPasswordController.text)
                                .whenComplete(() {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: Homepage(),
                                    type: PageTransitionType.bottomToTop),
                              );
                            });
                            void clearText() {
                              useremailController.clear();
                              userPasswordController.clear();
                            }
                          } else {
                            warningText(context, 'Fill all the data!');
                          }
                          void clearText() {
                            useremailController.clear();
                            userPasswordController.clear();
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .getUserAvatar),
                    backgroundColor: constantColors.redColor,
                    radius: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter name...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: useremailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Enter  password...',
                        hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        backgroundColor: constantColors.redColor,
                        child: Icon(FontAwesomeIcons.check,
                            color: constantColors.whiteColor),
                        onPressed: () {
                          if (useremailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .createAccount(useremailController.text,
                                    userPasswordController.text)
                                .whenComplete(() {
                              print('Creating collection...');
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .createUserCollection(context, {
                                'userpassword': userPasswordController.text,
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                'useremail': useremailController.text,
                                'username': userNameController.text,
                                'userimage': Provider.of<LandingUtils>(context,
                                        listen: false)
                                    .getUserAvatarUrl,
                              });
                            }).whenComplete(() {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: Homepage(),
                                    type: PageTransitionType.bottomToTop),
                              );
                            });
                          } else {
                            warningText(context, 'Fill all the data!');
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }


}

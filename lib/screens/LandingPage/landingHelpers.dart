import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/constants/Constantcolors.dart';
import 'package:thesocial1/screens/Homepage/Homepage.dart';
import 'package:thesocial1/screens/LandingPage/landingServices.dart';
import 'package:thesocial1/screens/LandingPage/landingUtils.dart';
import 'package:thesocial1/services/Authentication.dart';

class LandingHelpers with ChangeNotifier {
  bool passwordVisible = true;

  ConstantColors constantColors = ConstantColors();
  TextEditingController userPasswordController = TextEditingController();

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.65,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/login.png'))),
    );
  }

  Widget taglineText(BuildContext) {
    return Positioned(
      top: 450.0,
      left: 10.0,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 170.0,
        ),
        child: RichText(
          text: TextSpan(
              text: 'Are ',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0),
              children: <TextSpan>[
                TextSpan(
                  text: 'You ',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0),
                ),
                TextSpan(
                  text: ' Social',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0),
                ),
                TextSpan(
                  text: '?',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0),
                )
              ]),
        ),
      ),
    );
  }

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: 630.0,
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                emailAuthSheet(context);
              },
              child: Container(
                child: Icon(
                  EvaIcons.emailOutline,
                  color: constantColors.yellowColor,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.yellowColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Signing with Google');
                Provider.of<Authentication>(context, listen: false)
                    .signInWithGoogle()
                    .whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Homepage(),
                          type: PageTransitionType.leftToRight));
                });
              },
              child: Container(
                child: Icon(
                  FontAwesomeIcons.google,
                  color: constantColors.redColor,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.redColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            GestureDetector(
              onTap: () {
                emailSalvo(context);
              },
              child: Container(
                child: Icon(
                  EvaIcons.checkmark,
                  color: constantColors.blueColor,
                ),
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                    border: Border.all(color: constantColors.blueColor),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: 740.0,
      left: 20.0,
      right: 20.0,
      child: Container(
        child: Column(
          children: [
            Text("By continuing you agree theSocial's Terms of",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14.0)),
            Text("Services & Privacy Policy",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
          ],
        ),
      ),
    );
  }

  emailSalvo(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(

            height: MediaQuery
                .of(context)
                .size
                .height * 0.5,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))),
            child: Column(

              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Provider.of<LandingService>(context, listen: false)
                    .passwordLessSignIn(
                    context),

              ],
            ),
          );
        });
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.1,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))),
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
                          'Log in',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<LandingService>(context, listen: false)
                              .logInSheet(context);
                        }),
                    MaterialButton(
                        color: constantColors.redColor,
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .selectAvatarOptionsSheet(context);
                        })
                  ],
                )
              ],
            ),
          );
        });
  }
}
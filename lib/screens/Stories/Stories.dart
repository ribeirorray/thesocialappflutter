import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/services/Authentication.dart';

import '../../constants/Constantcolors.dart';

class Stories extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  Stories({required this.documentSnapshot}) {}

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: 10.0,
              width: 10.0,
              child: Column(
                children: [
                  Container(

                    child: Image.network(widget.documentSnapshot['image'],
                        fit: BoxFit.contain),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: constantColors.darkColor,
                  backgroundImage:
                      NetworkImage(widget.documentSnapshot['userimage']),
                  radius: 25.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: Column(
                    children: [
                      Text(widget.documentSnapshot['username'],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      Text(
                        '2 hours ago',
                        style: TextStyle(
                            color: constantColors.greenColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Provider.of<Authentication>(context, listen: false)
                            .getUserUid ==
                        widget.documentSnapshot['useruid']
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30.0,
                          width: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                FontAwesomeIcons.solidEye,
                                color: constantColors.yellowColor,
                                size: 16.0,
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        width: 0.0,
                        height: 0.0,
                      ),
                SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularCountDownTimer(
                    isTimerTextShown: false,
                    duration: 15,
                    fillColor: constantColors.blueColor,
                    height: 20.0,
                    width: 20.0,
                    ringColor: constantColors.darkColor,
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      EvaIcons.moreVertical,
                      color: constantColors.whiteColor,
                    ))
              ],
            ),
          ))
        ],
      ),
    );
  }
}

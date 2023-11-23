import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/Constantcolors.dart';
import '../../services/Authentication.dart';
import '../../utils/UploadPost.dart';
import '../Profile/ProfileHelpers.dart';

class Music extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            EvaIcons.settings2Outline,
            color: constantColors.lightBlueColor,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon:
            Icon(EvaIcons.logOutOutline, color: constantColors.greenColor),
            onPressed: () {

            },
          )
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
              text: 'My',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'Music',
                    style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ))
              ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: constantColors.blueGreyColor.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }


}

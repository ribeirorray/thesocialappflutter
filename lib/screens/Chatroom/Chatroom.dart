import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/screens/Chatroom/ChatroomHelpers.dart';

import '../../constants/Constantcolors.dart';

class Chatroom extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.blueGreyColor,
        child: Icon(FontAwesomeIcons.plus, color: constantColors.greenColor),
        onPressed: () {
          Provider.of<ChatRoomHelpers>(context, listen: false)
              .showCreateChatroomSheet(context);
        },
      ),
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(EvaIcons.moreVertical))
        ],
        leading: IconButton(
            onPressed: () {
              Provider.of<ChatRoomHelpers>(context, listen: false)
                  .showCreateChatroomSheet(context);
            },
            icon: Icon(FontAwesomeIcons.plus),
            color: constantColors.greenColor),
        title: RichText(
          text: TextSpan(
              text: 'Chat',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'Box',
                    style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ))
              ]),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatRoomHelpers>(context, listen: false)
            .showChatrooms(context),
      ),
    );
  }
}

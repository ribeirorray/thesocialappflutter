import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/screens/AltProfile/alt_profile_helper.dart';

import '../../constants/Constantcolors.dart';

class AltProfile extends StatelessWidget {
  late final String userUid;
  final ConstantColors constantColors = ConstantColors();

  AltProfile({required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Provider.of<AltProfileHelpers>(context, listen: false)
              .appBar(context),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Column(
                      children: [
                        Provider.of<AltProfileHelpers>(context, listen: false)
                            .headerProfile(context, snapshot, userUid),
                        Provider.of<AltProfileHelpers>(context, listen: false)
                            .divider(),
                        Provider.of<AltProfileHelpers>(context, listen: false)
                            .middleProfile(context, snapshot),
                        Provider.of<AltProfileHelpers>(context, listen: false)
                            .footerProfile(context, snapshot),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    );
                  }
                },
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ))),
        ));
  }
}

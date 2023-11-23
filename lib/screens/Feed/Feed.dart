import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial1/screens/Feed/FeedHelpers.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100), child: Provider.of<FeedHelpers>(context,listen: false).appBar(context)),
      body:PreferredSize( preferredSize: const Size.fromHeight(100), child: Provider.of<FeedHelpers>(context,listen: false).feedBody(context)) ,


    );
  }
}

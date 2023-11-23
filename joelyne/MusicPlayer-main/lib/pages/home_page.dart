import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/pages/list_music.dart';
import 'package:musicplayer/pages/upload.dart';
import 'package:musicplayer/pages/upload_url.dart';
import 'package:musicplayer/theme/colors.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: getBody(),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Center(
          child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: 400,
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.contain,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: primary.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      icon: Icon(Icons.add_box_outlined),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadURL()));
                      },
                      label: Text("Add Música pela URL"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: primary.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 23, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      icon: Icon(Icons.add_box_outlined),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Upload()));
                      },
                      label: Text("Add Música do Celular"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: primary.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 23, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      icon: Icon(Icons.archive_outlined),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListMusic()));
                      },
                      label: Text("Músicas Armazenadas"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

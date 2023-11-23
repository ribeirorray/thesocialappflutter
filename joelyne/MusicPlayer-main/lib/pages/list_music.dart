import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/pages/music_detail_page.dart';
import 'package:musicplayer/theme/colors.dart';
import 'package:page_transition/page_transition.dart';

class ListMusic extends StatefulWidget {
  const ListMusic({Key? key}) : super(key: key);

  @override
  State<ListMusic> createState() => _ListMusicState();
}

class _ListMusicState extends State<ListMusic> {
  @override
  void initState() {
    super.initState();
  }

  Future teste() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          backgroundColor: black,
          elevation: 0,
          title: Text('Lista de Músicas'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('musicas').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final files = snapshot.data!.docs;
              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index]['name'];
                  return ListTile(
                    title: Text(
                      file,
                      style: TextStyle(color: white),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.play_arrow_rounded,
                        size: 30,
                        color: primary,
                      ),
                      onPressed: () async {
                        var collection =
                            FirebaseFirestore.instance.collection('musicas');
                        var result = await collection.get();
                        collection.snapshots().listen((r) {
                          result = r;
                          var url = r.docs[index]['urlDownload'];
                          var name = r.docs[index]['name'];
                          var imagem = Image.asset("assets/images/musica.jpg");
                          Navigator.push(
                              context,
                              PageTransition(
                                  alignment: Alignment.bottomCenter,
                                  child: MusicDetailPage(
                                    title: '$name',
                                    songUrl: '$url',
                                  ),
                                  type: PageTransitionType.scale));
                        });
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro'));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/pages/list_music.dart';
import 'package:musicplayer/theme/colors.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    final db = FirebaseFirestore.instance
        .collection('musicas')
        .doc(pickedFile!.name)
        .set({'urlDownload': urlDownload, 'name': pickedFile!.name});

    setState(() {
      uploadTask = null;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: black,
        title: Text("Upload Músicas Biblioteca"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pickedFile != null)
              Expanded(
                  child: Container(
                color: Colors.deepPurple[100],
                child: Center(
                  child: Text(pickedFile!.name),
                ),
              )),
            SizedBox(
              height: 32,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              icon: Icon(Icons.attach_file),
              onPressed: selectFile,
              label: Text("Selecionar Música"),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: primary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              icon: Icon(Icons.upload),
              onPressed: uploadFile,
              label: Text("Enviar Música"),
            ),
            SizedBox(
              height: 32,
            ),
            buildProgress(),
          ],
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: grey,
                  color: Colors.deepPurple[100],
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });
}

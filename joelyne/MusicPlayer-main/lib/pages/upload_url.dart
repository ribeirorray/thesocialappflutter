import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/theme/colors.dart';

class UploadURL extends StatefulWidget {
  const UploadURL({Key? key}) : super(key: key);

  @override
  State<UploadURL> createState() => _UploadURLState();
}

class _UploadURLState extends State<UploadURL> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _songnameController = new TextEditingController();
  TextEditingController _songurlController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final stringField = TextFormField(
        autofocus: false,
        controller: _songurlController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.cloud_upload_outlined,
            color: primary,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Url da música",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final nameField = TextFormField(
        autofocus: false,
        controller: _songnameController,
        validator: (value) {
          if (value!.isEmpty) {
            return ("O nome é obrigatório");
          }
          return null;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.music_note,
            color: primary,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nome da música",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.deepPurple,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          String songname = _songnameController.text;
          String songurl = _songurlController.text;

          Map<String, dynamic> data = {
            "name": songname,
            "urlDownload": songurl,
          };
          if (songurl.isEmpty || songname.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Campos obrigatórios!"),
            ));
          } else {
            FirebaseFirestore.instance.collection("musicas").add(data);
            songname = _songnameController.text;
            songurl = _songurlController.text;
            Navigator.pop(context);
          }
        },
        child: Text("Salvar",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: black,
          title: Text("Upload Músicas URL"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          nameField,
                          SizedBox(
                            height: 15,
                          ),
                          stringField,
                          SizedBox(
                            height: 20,
                          ),
                          saveButton
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ));
  }
}

import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:musicplayer/pages/list_music.dart';
import 'package:musicplayer/pages/upload.dart';
import 'package:musicplayer/theme/colors.dart';

class MusicDetailPage extends StatefulWidget {
  final String title;
  final String songUrl;

  const MusicDetailPage({
    Key? key,
    required this.title,
    required this.songUrl,
  }) : super(key: key);
  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isRepeat = false;
  bool isLow = false;
  bool isFast = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String url = '';
  Color color = Colors.white;
  Color color1 = Colors.white;
  Color color2 = Colors.white;
  Color color3 = Colors.white;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.stop);

    final player = AudioCache();
    String url = widget.songUrl;
    audioPlayer.setSourceUrl(url);
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        position = Duration(seconds: 0);
        isPlaying = false;
        isRepeat = false;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  getAppBar() {
    return AppBar(
      backgroundColor: black,
      elevation: 0,
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Container(
                width: size.width - 60,
                height: size.width - 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/musica.jpg"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            width: size.width,
            height: 40,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18,
                          color: white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Slider(
            activeColor: primary,
            value: position.inSeconds.toDouble(),
            min: 0,
            max: duration.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);

              await audioPlayer.resume();
            }),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatTime(position),
                style: TextStyle(color: white.withOpacity(0.5)),
              ),
              Text(
                formatTime(duration - position),
                style: TextStyle(color: white.withOpacity(0.5)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.shuffle,
                    color: black,
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    if (isLow == false) {
                      audioPlayer.setPlaybackRate(0.5);
                      setState(() {
                        isLow = true;
                        color1 = primary;
                      });
                    } else if (isLow == true) {
                      audioPlayer.setPlaybackRate(1);
                      setState(() {
                        isLow = false;
                        color1 = white;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.keyboard_double_arrow_left_rounded,
                    color: color1.withOpacity(0.8),
                    size: 30,
                  )),
              IconButton(
                  iconSize: 50,
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                  },
                  icon: Container(
                    decoration:
                        BoxDecoration(color: primary, shape: BoxShape.circle),
                    child: Center(
                        child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 30,
                      color: white,
                    )),
                  )),
              IconButton(
                  onPressed: () {
                    if (isFast == false) {
                      audioPlayer.setPlaybackRate(1.5);
                      setState(() {
                        isFast = true;
                        color2 = primary;
                      });
                    } else if (isFast == true) {
                      audioPlayer.setPlaybackRate(1);
                      setState(() {
                        isFast = false;
                        color2 = white;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    color: color2.withOpacity(0.8),
                    size: 30,
                  )),
              IconButton(
                  onPressed: () {
                    if (isRepeat == false) {
                      audioPlayer.setReleaseMode(ReleaseMode.loop);
                      setState(() {
                        isRepeat = true;
                        color = primary;
                      });
                    } else if (isRepeat == true) {
                      audioPlayer.setReleaseMode(ReleaseMode.release);
                      setState(() {
                        isRepeat = false;
                        color = white;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.repeat,
                    color: color.withOpacity(0.8),
                    size: 30,
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    ));
  }
}

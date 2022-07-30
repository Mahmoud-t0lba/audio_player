// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'dart:math' as math;

import 'package:audio_manager/audio_manager.dart';
import 'package:audio_player/song_list.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  Duration? duration;
  Duration? position;
  double sliderValue = 0;
  PlayMode playMode = AudioManager.instance.playMode;

  final songsList = [
    {
      'title': 'Believer',
      'desc': 'Jessy - Astron',
      'url': 'assets/songs/believer.mp3',
      'coverUrl': 'assets/images/be.jpg'
    },
    {
      'title': 'Cherry Baby',
      'desc': 'Cristian Tarcea - Erin Danet, Cristian Tarcea',
      'url': 'assets/songs/cherry.mp3',
      'coverUrl': 'assets/images/ch.jpg'
    },
    {
      'title': 'Our Streets',
      'desc': 'Dj Kantik',
      'url': 'assets/songs/stress.mp3',
      'coverUrl': 'assets/images/our.jpg'
    },
    {
      'title': 'Dessert',
      'desc': 'Dawin',
      'url': 'assets/songs/dessert.mp3',
      'coverUrl': 'assets/images/des.jpg'
    },
    {
      'title': 'Lost in Love',
      'desc': 'Akcent Music - Adrian Sina, Ackym, Tamy ',
      'url': 'assets/songs/love.mp3',
      'coverUrl': 'assets/images/lost.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Audio Player',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xffA56169),
                Color(0xff83565A),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                const Color(0xffA56169),
                const Color(0xff83565A).withOpacity(.7),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 200.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xff332e3f),
                      Color(0xff372c38),
                    ]),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: playerHeader(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Playlist (${songsList.length})',
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: SongList(songsList),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setupAudio();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    AudioManager.instance.release();
    controller?.dispose();
    super.dispose();
  }

  AnimationController? controller;
  double getAngle() {
    var value = controller?.value ?? 0;
    return value * 2 * math.pi;
  }

  Widget playerHeader() {
    return Row(
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          percent: sliderValue,
          progressColor: const Color(0xffA56169),
          center: AnimatedBuilder(
            animation: controller!,
            builder: (_, child) {
              return Transform.rotate(
                angle: AudioManager.instance.isPlaying ? getAngle() : 0,
                child: child,
              );
            },
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: Image.asset(
                  AudioManager.instance.info?.coverUrl ??
                      'assets/images/disc.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    AudioManager.instance.info?.title ?? 'Song Name',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AudioManager.instance.info?.desc ?? 'Artist Name',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.cyan.withOpacity(0.3),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          AudioManager.instance.previous();
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color(0xffA56169),
                              Color(0xff83565A),
                            ]),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Center(
                      child: IconButton(
                        onPressed: () async {
                          AudioManager.instance.playOrPause();
                        },
                        padding: const EdgeInsets.all(0.0),
                        icon: Icon(
                          AudioManager.instance.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.cyan.withOpacity(0.3),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          AudioManager.instance.next();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  duration != null
                      ? Text(
                          formatDuration(duration!, position!),
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 5),
                  duration != null
                      ? Text(
                          formatDurationLeft(duration!, position!),
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        )
                      : const SizedBox(),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  String formatDuration(Duration ds, Duration p) {
    if (ds == null || p == null) return '--:--';
    // var d = ds - p;
    var d = p;

    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format =
        "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
    print(p.inSeconds);
    print(ds.inSeconds);
    sliderValue = (p.inSeconds / ds.inSeconds);
    return 'Time : $format';
  }

  String formatDurationLeft(Duration ds, Duration p) {
    if (ds == null || p == null) return '--:--';
    var d = ds - p;

    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format =
        "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
    print(p.inSeconds);
    print(ds.inSeconds);
    sliderValue = (p.inSeconds / ds.inSeconds);
    return 'Time Left: $format';
  }

  void setupAudio() {
    List<AudioInfo> list = [];
    for (var item in songsList) {
      list.add(AudioInfo(item['url']!,
          title: item['title']!,
          desc: item['desc']!,
          coverUrl: item['coverUrl']!));
    }

    AudioManager.instance.audioList = list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: true);

    AudioManager.instance.onEvents(
      (events, args) {
        switch (events) {
          case AudioManagerEvents.start:
            print(
                'start load data callback, curIndex is ${AudioManager.instance.curIndex}');
            position = AudioManager.instance.position;
            duration = AudioManager.instance.duration;
            setState(() {});
            break;
          case AudioManagerEvents.ready:
            print('ready to play');
            position = AudioManager.instance.position;
            duration = AudioManager.instance.duration;
            setState(() {});

            break;
          case AudioManagerEvents.seekComplete:
            position = AudioManager.instance.position;
            setState(() {});
            print('seek event is completed. position is [$args]/ms');
            break;
          case AudioManagerEvents.buffering:
            print('buffering $args');
            break;
          case AudioManagerEvents.playstatus:
            isPlaying = AudioManager.instance.isPlaying;
            setState(() {});
            break;
          case AudioManagerEvents.timeupdate:
            position = AudioManager.instance.position;
            setState(() {});
            AudioManager.instance.updateLrc(args['position'].toString());
            break;
          case AudioManagerEvents.error:
            setState(() {});
            break;
          case AudioManagerEvents.ended:
            AudioManager.instance.next();
            break;
          case AudioManagerEvents.volumeChange:
            setState(() {});
            break;
          default:
            break;
        }
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:music_playeer/models/music.dart';
import 'package:music_playeer/pages/utils.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:audioplayers/audioplayers.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:alan_voice/alan_voice.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
  String? colorHex;

  List<MyMusic> musics = [
    MyMusic(
        id: 1,
        name: "Alan",
        url: "http://sc-bb.1.fm:8017/",
        image:
            "https://i.pinimg.com/564x/11/3e/32/113e32774474843d2a13f938b892e287.jpg",
        color: "0xff221420")
  ];
  bool _isplaying = false;
  Color? selecedcolor;

  @override
  void initState() {
    super.initState();
    fetchmusic();
    setupAlan();
  }

  setupAlan() {
    AlanVoice.addButton(
        "a0226152fb6107d92516848fe84c59282e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "play":
        _playMusic("assets/audios/ak.mp3");
        break;
      case "stop":
        assetsAudioPlayer.stop();
        break;
    }
  }

  fetchmusic() async {
    final musicjson = await rootBundle.loadString("assets/music.json");
    musics = MyMusicList.fromJson(musicjson).musics;
    print(musics);

    setState(() {});
  }

  _playMusic(String url) {
    assetsAudioPlayer.open(
      Audio(url),
      autoStart: true,
      showNotification: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(colors: [
                  AIColors.primaryColor2,
                  selecedcolor ?? AIColors.primaryColor1
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              )
              .make(),
          [
            AppBar(
              title: "AI Player".text.xl4.white.make().shimmer(
                  primaryColor: Vx.purple300, secondaryColor: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
            ).h(100.0).p16(),
            20.heightBox,
            " Start with - Hey Alan".text.semiBold.italic.white.make()
          ].vStack(),
          musics != Null
              ? VxSwiper.builder(
                  itemCount: musics.length,
                  aspectRatio: 1.0,
                  onPageChanged: (index) {
                    final colorHex = musics[index].color;
                    selecedcolor = Color(int.parse(colorHex));
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    final mus = musics[index];
                    return VxBox(
                            child: ZStack([
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VStack(
                          [mus.name.text.xl2.white.bold.make()],
                          crossAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: [
                          Icon(
                            _isplaying
                                ? CupertinoIcons.stop_circle
                                : CupertinoIcons.play_circle,
                            color: Colors.white,
                          ),
                          10.heightBox,
                          "Double Tap To Play".text.gray300.make()
                        ].vStack(),
                      ),
                    ]))
                        .bgImage(
                          DecorationImage(
                            image: NetworkImage(mus.image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken),
                          ),
                        )
                        .border(color: Colors.black, width: 5)
                        .withRounded(value: 60)
                        .make()
                        .onInkDoubleTap(() {
                      if (_isplaying) {
                        assetsAudioPlayer.stop();
                        setState(() {
                          _isplaying = false;
                        });
                      } else {
                        _playMusic(mus.url);
                        setState(() {
                          _isplaying = true;
                        });
                      }
                    }).p16();
                  }).centered()
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              _isplaying
                  ? CupertinoIcons.stop_circle
                  : CupertinoIcons.play_circle,
              color: Colors.white,
              size: 50.0,
            ).onTap(() {
              if (_isplaying) {
                assetsAudioPlayer.stop();
                setState(() {
                  _isplaying = false;
                });
              } else {
                _playMusic("assets/audios/ak.mp3");
                setState(() {
                  _isplaying = true;
                });
              }
            }),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}

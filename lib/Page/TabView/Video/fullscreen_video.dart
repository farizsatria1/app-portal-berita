import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  final String title;

  const FullScreenVideoPage({required this.videoUrl, required this.videoId,required this.title});

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent
        ),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: widget.videoId,
            flags: YoutubePlayerFlags(
              autoPlay: true,
            ),
          ),
          aspectRatio: 16 / 8.4,
          progressColors: ProgressBarColors(
            playedColor: Colors.redAccent,
            handleColor: Colors.red,
            bufferedColor: Colors.grey,
            backgroundColor: Colors.white38,
          ),
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}

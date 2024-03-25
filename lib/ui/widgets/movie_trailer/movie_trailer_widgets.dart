import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatefulWidget {
  final String yotubeKey;

  const MovieTrailerWidget({Key? key, required this.yotubeKey})
      : super(key: key);

  @override
  _MovieTrailerState createState() => _MovieTrailerState();
}

class _MovieTrailerState extends State<MovieTrailerWidget> {
 late final  YoutubePlayerController _controller;

@override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.yotubeKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

 @override
 Widget build(BuildContext context) {
   final player = YoutubePlayer(
     controller: _controller,
     showVideoProgressIndicator: true,
   );
   return YoutubePlayerBuilder(
     player: player,
     builder: (context, player) {
       return Scaffold(
         appBar: AppBar(
           title: const Text('Трейлер'),
         ),
         body: Center(
           child: player,
         ),
       );
     },
   );
 }
}
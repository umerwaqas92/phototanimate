import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class PlayVideo extends StatefulWidget {

  String url="";


  PlayVideo(this.url);

  @override
  _PlayVideoState createState() => _PlayVideoState();
}



class _PlayVideoState extends State<PlayVideo> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BetterPlayer.network(widget.url);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example player"),
      ),
      body: AspectRatio(
        aspectRatio: 9 / 9,
        child: BetterPlayer.network(
          widget.url,
          betterPlayerConfiguration: BetterPlayerConfiguration(
            aspectRatio: 9 / 9,
          ),
        ),
      ),
    );
  }
}

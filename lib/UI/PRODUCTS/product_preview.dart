import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pal/Constant/color.dart';
import '../../Common/appbar.dart';
import 'package:video_player/video_player.dart';

class ProductPreview extends StatefulWidget {
  final String path;
  ProductPreview({@required this.path});
  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  VideoPlayerController _controller;
  bool isPlaying = true;
  String baseUrl = "https://generalstore.krishnasoftweb.com/";
  Duration  position = Duration();
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(baseUrl + widget.path)..initialize().then((_) {setState(() {
      _controller.play();
      _controller.setVolume(1.0);
      _controller.setLooping(true);
    });});
    _controller.addListener(() {setState(() {

    });});
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Product Preview"),
      body: Center(
        child: _controller.value.initialized ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_controller),
            ),
            VideoProgressIndicator(_controller, allowScrubbing: true),
          ],
        ) : SizedBox(height: 30, width: 30, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),),),
      ),
      floatingActionButton: _controller.value.initialized ? FloatingActionButton(backgroundColor: AppColors.primaryColor, elevation: 0, onPressed: _controller.value.isBuffering ? null : () {
        if(_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.initialize();
          _controller.play();
        }
        print(_controller.value.duration.inSeconds);
      }, child: _controller.value.isBuffering ? SizedBox(height: 25, width: 25, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),) : Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),) : null
    );
  }
}

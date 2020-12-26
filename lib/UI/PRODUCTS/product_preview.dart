import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../SERVICES/urls.dart';
import 'package:video_player/video_player.dart';

class ProductPreview extends StatefulWidget {
  ProductPreview({Key key}) : super(key: key);
  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    _controller = VideoPlayerController.network(
      Urls.imageBaseUrl + 'assets/video/product/20201210165209.mp4',
    )..initialize();
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      body: FutureBuilder(builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }, future: _initializeVideoPlayerFuture, ),
    );
  }
}

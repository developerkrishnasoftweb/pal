import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constant/strings.dart';
import '../../localization/localizations_constraints.dart';
import '../../ui/widgets/appbar.dart';
import '../../ui/widgets/circular_progress_indicator.dart';
import 'package:video_player/video_player.dart';


class ProductPreview extends StatefulWidget {
  final String path;
  ProductPreview({@required this.path});
  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  VideoPlayerController _controller;
  bool isPlaying = false;
  String baseUrl = "https://generalstore.krishnasoftweb.com/";
  Duration position = Duration();
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(baseUrl + widget.path)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setVolume(1.0);
        });
      });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: translate(context, LocaleStrings.productPreview)),
      body: Center(
          child: Stack(
        alignment: Alignment.center,
        children: [
          _controller.value.initialized
              ? GestureDetector(
                  onTap: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                      setState(() {
                        isPlaying = true;
                      });
                    } else {
                      _controller.initialize();
                      _controller.play();
                      setState(() {
                        isPlaying = false;
                      });
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoPlayer(_controller),
                      ),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
                  ),
                )
              : SizedBox(
                  height: 30,
                  width: 30,
                  child: circularProgressIndicator(),
                ),
          isPlaying
              ? Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_arrow,
                    size: 50,
                    color: Colors.white,
                  ),
                )
              : SizedBox()
        ],
      )),
    );
  }
}

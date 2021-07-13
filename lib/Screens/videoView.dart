import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pressfame_new/constant/global.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoView extends StatefulWidget {
  final String url;
  final bool play;
  final String id;

  VideoView({this.url, this.play, this.id});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<VideoView> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  VideoPlayerController controller;

  Duration duration, position;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.network(
      widget.url,
      //closedCaptionFile: _loadCaptions(),
    );

    controller.addListener(() {
      if (mounted) setState(() {});
    });
    controller.setLooping(true);
    controller.initialize();

    if (widget.play != null && widget.play == true) {
      controller.play();
      controller.setLooping(true);
    }

    duration = controller.value.duration;
    position = controller.value.position;
    if (duration != null && position != null)
      position = (position > duration) ? duration : position;
  }

  @override
  void didUpdateWidget(VideoView oldWidget) {
    if (widget.play != null &&
        widget.play == true &&
        oldWidget.play != widget.play) {
      if (widget.play) {
        controller.play();
        controller.setLooping(true);
      } else {
        controller.pause();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appColorBlack,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
             // height: 300,
              child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VisibilityDetector(
                      key:
                          Key(DateTime.now().microsecondsSinceEpoch.toString()),
                      onVisibilityChanged: (VisibilityInfo info) {
                        debugPrint(
                            "${info.visibleFraction} of my widget is visible");
                        if (info.visibleFraction == 0) {
                          if (controller != null) controller.pause();
                        } else {
                          if (controller != null) controller.play();
                        }
                      },
                      child: VideoPlayer(controller))),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, VideoPlayerValue value, child) {
              return Padding(
                padding: const EdgeInsets.only(top: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      value.position.inMinutes.toString() +
                          ":" +
                          value.position.inSeconds.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

//  Container(
//         // color: Colors.grey,
//         //  height: SizeConfig.blockSizeVertical * 40,
//         width: SizeConfig.screenWidth,
//         child: AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: <Widget>[
//               widget.play == null
//                   ? VisibilityDetector(
//                       key: Key(
//                           DateTime.now().microsecondsSinceEpoch.toString()),
//                       onVisibilityChanged: (VisibilityInfo info) {
//                         debugPrint(
//                             "${info.visibleFraction} of my widget is visible");
//                         if (info.visibleFraction == 0) {
//                           if (controller != null) controller.pause();
//                         } else {
//                           if (controller != null) controller.play();
//                         }
//                       },
//                       child: VideoPlayer(controller))
//                   : VideoPlayer(controller),

//               // ClosedCaption(text: controller.value.caption.text),
//               _PlayPauseOverlay(controller: controller, id: widget.id),
//               //  VideoProgressIndicator(_controller, allowScrubbing: true),
//             ],
//           ),
//         ),
//       ),

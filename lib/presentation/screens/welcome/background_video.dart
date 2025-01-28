import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class BackgroundVideo extends StatefulWidget {
  const BackgroundVideo({super.key});

  @override
  State<BackgroundVideo> createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late final VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.asset('assets/background/welcome_background.mp4')
    ..initialize().then((_){
      controller.play();
      controller.setLooping(true);
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) => VideoPlayer(controller);
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewer extends StatefulWidget {
  final String? title;
  final String url;

  const VideoViewer({
    Key? key,
    required this.url,
    this.title,
  }) : super(key: key);

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late String _title;
  late String _url;
  late Widget _body;
  late VideoPlayerController _videoController;
  var _videoPlaying = true;

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? '';
    _url = widget.url;
    _videoController = VideoPlayerController.network(_url)
      ..initialize().then((_) => setState(() {}))
      ..play()
      ..setLooping(true);
  }

  void _initBody() {
    _body = Center(
      child: GestureDetector(
        onTap: () {
          if (_videoController.value.isPlaying) {
            _videoController.pause();
          } else {
            _videoController.play();
          }
          setState(() => _videoPlaying = !_videoPlaying);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video player
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            ),

            // Loading indicator
            if (_videoController.value.isBuffering) ...[
              const CircularProgressIndicator(color: Colors.white),
            ],

            // Play/pause button
            AnimatedOpacity(
              opacity: _videoPlaying ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.play_arrow),
                  ),
                ),
              ),
            ),

            // Seekbar
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: AnimatedOpacity(
                opacity: _videoPlaying ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: VideoProgressIndicator(
                  _videoController,
                  allowScrubbing: _videoPlaying ? false : true,
                  colors: VideoProgressColors(
                    backgroundColor: Colors.grey,
                    bufferedColor: Theme.of(context).primaryColorLight,
                    playedColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initBody();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: TextButton(
          style: TextButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
          ),
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_title),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: EdgeInsets.zero,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.download),
            onPressed: () {},
          ),
        ],
      ),
      body: _body,
    );
  }
}
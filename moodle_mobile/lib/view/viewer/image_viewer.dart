import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String title;
  final String url;
  final String base64;

  const ImageViewer({
    Key? key,
    this.title = '',
    this.url = '',
    this.base64 = '',
  }) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late String _title;
  late String _url;
  late String _base64;
  late Widget _body;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _url = widget.url;
    _base64 = widget.base64;
  }

  void _initBody() {
    _body = Center(
      child: PhotoView(
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered,
        imageProvider: _base64.isNotEmpty
            ? Image.memory(base64Decode(_base64)).image
            : NetworkImage(_url),
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
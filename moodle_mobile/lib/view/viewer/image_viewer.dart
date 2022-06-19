import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moodle_mobile/data/network/apis/file/file_api.dart';
import 'package:moodle_mobile/store/user/user_store.dart';
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
  late UserStore _userStore;

  @override
  void initState() {
    _userStore = GetIt.instance<UserStore>();
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

  downloadFile() async {
    String fileName = "";
    if (_url.isNotEmpty) {
      List<String> list = _url.split('/');
      fileName = list.length > 1 ? list.last : _title;
    } else {
      fileName = DateTime.now().microsecondsSinceEpoch.toString() + ".png";
    }

    await FileApi().downloadFile(_userStore.user.token, _url, fileName);
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
        title: Text(
          _title,
          overflow: TextOverflow.clip,
        ),
        actions: [
          _base64.isNotEmpty
              ? Container()
              : TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.download),
                  onPressed: () async {
                    await downloadFile();
                  },
                ),
        ],
      ),
      body: _body,
    );
  }
}

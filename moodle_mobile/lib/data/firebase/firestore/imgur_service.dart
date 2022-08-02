import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_mobile/data/firebase/constants/collections.dart';
import 'package:moodle_mobile/data/firebase/firebase_helper.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/models/imgur/imgur_auth_token.dart';
import 'package:moodle_mobile/models/imgur/imgur_image.dart';
import 'package:moodle_mobile/models/imgur/imgur_token.dart';

class ImgurService {
  static FirebaseFirestore get _db => FirebaseHelper.db;

  /// Get the imgur token from Firebase, refresh if it's expired or not exist
  static Future<ImgurToken> getToken() async {
    final doc = await _db.collection(Collections.imgur).doc('token').get();
    if (!doc.exists) return await refreshToken();
    final token = ImgurToken.fromJson(doc.data() ?? {});
    if (token.expireDate?.isBefore(DateTime.now()) ?? true) {
      return await refreshToken();
    }
    return ImgurToken.fromJson(doc.data() ?? {});
  }

  /// Save the imgur token to Firebase
  static Future<ImgurToken> setToken(ImgurToken token) async {
    await _db.collection(Collections.imgur).doc('token').set(token.toJson());
    return token;
  }

  /// Refresh the imgur token and save it to Firebase
  static Future<ImgurToken> refreshToken() async {
    try {
      final authToken = await getAuthToken();
      final res = await http.post(
        Uri.parse(Endpoints.imgurGenerateToken),
        body: {
          'refresh_token': authToken.refresh_token,
          'client_id': authToken.client_id,
          'client_secret': authToken.client_secret,
          'grant_type': authToken.grant_type,
        },
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (!(data['success'] ?? true)) throw Exception(data);
      final token = ImgurToken.fromJson(data);
      return await setToken(token);
    } catch (e) {
      if (kDebugMode) print('Refresh token error: $e');
      rethrow;
    }
  }

  /// Get the auth token from Firebase, this token must be refresh manually
  /// Note: this token is used to generate the imgur token,
  /// not the imgur token itself
  static Future<ImgurAuthToken> getAuthToken() async {
    final doc = await _db.collection(Collections.imgur).doc('auth').get();
    if (!doc.exists) {
      throw Exception('Auth token not found');
    }
    return ImgurAuthToken.fromJson(doc.data() ?? {});
  }

  /// Upload image to Imgur and return the image url
  static Future<String> uploadImage(String base64) async {
    try {
      final token = await getToken();
      final res = await http.post(
        Uri.parse(Endpoints.imgurUploadImage),
        headers: {'Authorization': 'Bearer ${token.access_token}'},
        body: {'image': base64},
      );
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (!(data['success'] ?? true)) throw Exception(data);
      final image = ImgurImage.fromJson(data['data']);
      return image.link ?? '';
    } catch (e) {
      if (kDebugMode) print('Refresh token error: $e');
      rethrow;
    }
  }

  /// Upload image to Imgur and return a img tag
  static Future<String> uploadImageForHtml(String base64, [String? alt]) async {
    final url = await uploadImage(base64);
    if (url.isEmpty) throw 'Upload failed';
    return getHtmlFromUrl(url, alt);
  }

  static String getHtmlFromUrl(String url, [String? alt]) =>
      '<img src="$url" alt="${alt ?? 'image'}"/>';

  /// Choose an image from the device and return a compressed base64 data
  static Future<String> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) throw 'No image selected';
    final path = result.files[0].path;
    if (path == null) throw 'No path found';
    final compressed = await _compressFile(path);
    return base64Encode(compressed.toList());
  }

  static Future<Uint8List> _compressFile(String path, [int? quality]) async {
    final file = File(path);
    final result = await FlutterImageCompress.compressWithFile(
          path,
          format: CompressFormat.jpeg,
          minHeight: 1920,
          minWidth: 1080,
          quality: quality ?? 50,
        ) ??
        Uint8List(0);
    if (kDebugMode) {
      print('Compressed ${await file.length()} to ${result.length}');
    }
    return result;
  }
}
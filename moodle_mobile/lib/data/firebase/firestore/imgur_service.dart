import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_mobile/data/firebase/constants/collections.dart';
import 'package:moodle_mobile/data/firebase/firebase_helper.dart';
import 'package:moodle_mobile/data/network/constants/endpoints.dart';
import 'package:moodle_mobile/models/imgur/imgur_auth_token.dart';
import 'package:moodle_mobile/models/imgur/imgur_image.dart';
import 'package:moodle_mobile/models/imgur/imgur_token.dart';

class ImgurService {
  static FirebaseFirestore get _db => FirebaseHelper.db;

  static Future<ImgurToken> getToken() async {
    final doc = await _db.collection(Collections.imgur).doc('token').get();
    if (!doc.exists) return await refreshToken();
    final token = ImgurToken.fromJson(doc.data() ?? {});
    if (token.expireDate?.isBefore(DateTime.now()) ?? true) {
      return await refreshToken();
    }
    return ImgurToken.fromJson(doc.data() ?? {});
  }

  static Future<ImgurToken> setToken(ImgurToken token) async {
    await _db.collection(Collections.imgur).doc('token').set(token.toJson());
    return token;
  }

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

  static Future<ImgurAuthToken> getAuthToken() async {
    final doc = await _db.collection(Collections.imgur).doc('auth').get();
    if (!doc.exists) {
      throw Exception('Auth token not found');
    }
    return ImgurAuthToken.fromJson(doc.data() ?? {});
  }

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
}
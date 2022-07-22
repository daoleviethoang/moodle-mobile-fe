// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'imgur_image.g.dart';

@JsonSerializable()
class ImgurImage {
  final String? id;
  final String? title;
  final String? description;
  final int? datetime;
  final String? type;
  final bool? animated;
  final int? width;
  final int? height;
  final int? size;
  final int? views;
  final int? bandwidth;
  final double? vote;
  final bool? favorite;
  final bool? nsfw;
  final String? section;
  final String? accountUrl;
  final int? accountId;
  final bool? isAd;
  final bool? inMostViral;
  final List<String>? tags;
  final int? adType;
  final String? adUrl;
  final bool? inGallery;
  final String? deletehash;
  final String? name;
  final String? link;

  ImgurImage({
    this.id,
    this.title,
    this.description,
    this.datetime,
    this.type,
    this.animated,
    this.width,
    this.height,
    this.size,
    this.views,
    this.bandwidth,
    this.vote,
    this.favorite,
    this.nsfw,
    this.section,
    this.accountUrl,
    this.accountId,
    this.isAd,
    this.inMostViral,
    this.tags,
    this.adType,
    this.adUrl,
    this.inGallery,
    this.deletehash,
    this.name,
    this.link,
  });

  factory ImgurImage.fromJson(Map<String, dynamic> json) =>
      _$ImgurImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImgurImageToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}
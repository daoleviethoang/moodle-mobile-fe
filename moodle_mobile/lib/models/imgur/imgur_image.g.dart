// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imgur_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImgurImage _$ImgurImageFromJson(Map<String, dynamic> json) => ImgurImage(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      datetime: json['datetime'] as int?,
      type: json['type'] as String?,
      animated: json['animated'] as bool?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      size: json['size'] as int?,
      views: json['views'] as int?,
      bandwidth: json['bandwidth'] as int?,
      vote: (json['vote'] as num?)?.toDouble(),
      favorite: json['favorite'] as bool?,
      nsfw: json['nsfw'] as bool?,
      section: json['section'] as String?,
      accountUrl: json['accountUrl'] as String?,
      accountId: json['accountId'] as int?,
      isAd: json['isAd'] as bool?,
      inMostViral: json['inMostViral'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      adType: json['adType'] as int?,
      adUrl: json['adUrl'] as String?,
      inGallery: json['inGallery'] as bool?,
      deletehash: json['deletehash'] as String?,
      name: json['name'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$ImgurImageToJson(ImgurImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'datetime': instance.datetime,
      'type': instance.type,
      'animated': instance.animated,
      'width': instance.width,
      'height': instance.height,
      'size': instance.size,
      'views': instance.views,
      'bandwidth': instance.bandwidth,
      'vote': instance.vote,
      'favorite': instance.favorite,
      'nsfw': instance.nsfw,
      'section': instance.section,
      'accountUrl': instance.accountUrl,
      'accountId': instance.accountId,
      'isAd': instance.isAd,
      'inMostViral': instance.inMostViral,
      'tags': instance.tags,
      'adType': instance.adType,
      'adUrl': instance.adUrl,
      'inGallery': instance.inGallery,
      'deletehash': instance.deletehash,
      'name': instance.name,
      'link': instance.link,
    };

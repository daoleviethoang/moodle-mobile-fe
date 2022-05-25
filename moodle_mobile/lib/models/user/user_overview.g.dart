// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserOverview _$UserOverviewFromJson(Map<String, dynamic> json) => UserOverview(
      id: json['id'] as int?,
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      firstaccess: json['firstaccess'] as int?,
      lastaccess: json['lastaccess'] as int?,
      suspended: json['suspended'] as bool?,
      description: json['description'] as String?,
      descriptionformat: json['descriptionformat'] as int?,
      profileimageurlsmall: json['profileimageurlsmall'] as String?,
      profileimageurl: json['profileimageurl'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$UserOverviewToJson(UserOverview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'firstaccess': instance.firstaccess,
      'lastaccess': instance.lastaccess,
      'suspended': instance.suspended,
      'description': instance.description,
      'descriptionformat': instance.descriptionformat,
      'profileimageurlsmall': instance.profileimageurlsmall,
      'profileimageurl': instance.profileimageurl,
      'city': instance.city,
      'country': instance.country,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      id: json['id'] as int,
      fullname: json['fullname'] as String,
      email: json['email'] as String?,
      firstaccess: json['firstaccess'] as int?,
      lastaccess: json['lastaccess'] as int?,
      lastcourseaccess: json['lastcourseaccess'] as int?,
      description: json['description'] as String?,
      descriptionformat: json['descriptionformat'] as int?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      profileimageurlsmall: json['profileimageurlsmall'] as String?,
      profileimageurl: json['profileimageurl'] as String?,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      enrolledcourses: (json['enrolledcourses'] as List<dynamic>?)
          ?.map((e) => EnrolledCourse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'firstaccess': instance.firstaccess,
      'lastaccess': instance.lastaccess,
      'lastcourseaccess': instance.lastcourseaccess,
      'description': instance.description,
      'descriptionformat': instance.descriptionformat,
      'city': instance.city,
      'country': instance.country,
      'profileimageurlsmall': instance.profileimageurlsmall,
      'profileimageurl': instance.profileimageurl,
      'roles': instance.roles,
      'enrolledcourses': instance.enrolledcourses,
    };

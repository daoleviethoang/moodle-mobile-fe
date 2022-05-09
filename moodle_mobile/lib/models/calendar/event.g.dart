// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      descriptionformat: json['descriptionformat'] as int?,
      location: json['location'] as String?,
      categoryid: json['categoryid'] as int?,
      groupid: json['groupid'] as int?,
      userid: json['userid'] as int?,
      repeatid: json['repeatid'] as int?,
      eventcount: json['eventcount'] as int?,
      component: json['component'] as String?,
      modulename: json['modulename'] as String?,
      instance: json['instance'] as int?,
      eventtype: json['eventtype'] as String?,
      timestart: json['timestart'] as int?,
      timeduration: json['timeduration'] as int?,
      timesort: json['timesort'] as int?,
      timeusermidnight: json['timeusermidnight'] as int?,
      visible: json['visible'] as int?,
      timemodified: json['timemodified'] as int?,
      icon: json['icon'] == null
          ? null
          : CalendarIcon.fromJson(json['icon'] as Map<String, dynamic>),
      course: json['course'] == null
          ? null
          : CourseCategoryCourse.fromJson(
              json['course'] as Map<String, dynamic>),
      subscription: json['subscription'] == null
          ? null
          : CalendarSubscription.fromJson(
              json['subscription'] as Map<String, dynamic>),
      canedit: json['canedit'] as bool?,
      candelete: json['candelete'] as bool?,
      deleteurl: json['deleteurl'] as String?,
      editurl: json['editurl'] as String?,
      viewurl: json['viewurl'] as String?,
      formattedtime: json['formattedtime'] as String?,
      isactionevent: json['isactionevent'] as bool?,
      iscourseevent: json['iscourseevent'] as bool?,
      iscategoryevent: json['iscategoryevent'] as bool?,
      groupname: json['groupname'] as String?,
      normalisedeventtype: json['normalisedeventtype'] as String?,
      normalisedeventtypetext: json['normalisedeventtypetext'] as String?,
      url: json['url'] as String?,
      islastday: json['islastday'] as bool?,
      popupname: json['popupname'] as String?,
      mindaytimestamp: json['mindaytimestamp'] as int?,
      mindayerror: json['mindayerror'] as String?,
      maxdaytimestamp: json['maxdaytimestamp'] as int?,
      maxdayerror: json['maxdayerror'] as String?,
      draggable: json['draggable'] as bool?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'descriptionformat': instance.descriptionformat,
      'location': instance.location,
      'categoryid': instance.categoryid,
      'groupid': instance.groupid,
      'userid': instance.userid,
      'repeatid': instance.repeatid,
      'eventcount': instance.eventcount,
      'component': instance.component,
      'modulename': instance.modulename,
      'instance': instance.instance,
      'eventtype': instance.eventtype,
      'timestart': instance.timestart,
      'timeduration': instance.timeduration,
      'timesort': instance.timesort,
      'timeusermidnight': instance.timeusermidnight,
      'visible': instance.visible,
      'timemodified': instance.timemodified,
      'icon': instance.icon,
      'course': instance.course,
      'subscription': instance.subscription,
      'canedit': instance.canedit,
      'candelete': instance.candelete,
      'deleteurl': instance.deleteurl,
      'editurl': instance.editurl,
      'viewurl': instance.viewurl,
      'formattedtime': instance.formattedtime,
      'isactionevent': instance.isactionevent,
      'iscourseevent': instance.iscourseevent,
      'iscategoryevent': instance.iscategoryevent,
      'groupname': instance.groupname,
      'normalisedeventtype': instance.normalisedeventtype,
      'normalisedeventtypetext': instance.normalisedeventtypetext,
      'url': instance.url,
      'islastday': instance.islastday,
      'popupname': instance.popupname,
      'mindaytimestamp': instance.mindaytimestamp,
      'mindayerror': instance.mindayerror,
      'maxdaytimestamp': instance.maxdaytimestamp,
      'maxdayerror': instance.maxdayerror,
      'draggable': instance.draggable,
    };

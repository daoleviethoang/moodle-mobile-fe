import 'package:moodle_mobile/models/assignment/submission.dart';

class AttemptAssignment {
  Submission? submission;
  bool? submissionsenabled;
  bool? locked;
  bool? graded;
  bool? canedit;
  bool? caneditowner;
  bool? cansubmit;
  bool? blindmarking;
  String? gradingstatus;

  AttemptAssignment({
    this.submission,
    this.submissionsenabled,
    this.locked,
    this.graded,
    this.canedit,
    this.caneditowner,
    this.cansubmit,
    this.blindmarking,
    this.gradingstatus,
  });

  AttemptAssignment.fromJson(Map<String, dynamic> json) {
    submission = json['submission'] != null
        ? Submission.fromJson(json['submission'])
        : null;
    submissionsenabled = json['submissionsenabled'];
    locked = json['locked'];
    graded = json['graded'];
    canedit = json['canedit'];
    caneditowner = json['caneditowner'];
    cansubmit = json['cansubmit'];
    blindmarking = json['blindmarking'];
    gradingstatus = json['gradingstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (submission != null) {
      data['submission'] = submission?.toJson();
    }
    data['submissionsenabled'] = submissionsenabled;
    data['locked'] = locked;
    data['graded'] = graded;
    data['canedit'] = canedit;
    data['caneditowner'] = caneditowner;
    data['cansubmit'] = cansubmit;
    data['blindmarking'] = blindmarking;
    data['gradingstatus'] = gradingstatus;
    return data;
  }
}
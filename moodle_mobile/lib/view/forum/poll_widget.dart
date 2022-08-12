import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/constants/colors.dart';
import 'package:moodle_mobile/data/firebase/firestore/polls_service.dart';
import 'package:moodle_mobile/models/poll/poll.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:moodle_mobile/view/forum/add_post/edit_poll_screen.dart';

class PollContainer extends StatefulWidget {
  final String? courseId;
  final String? userId;
  final bool isTeacher;
  const PollContainer(
      {Key? key, this.courseId, this.userId, this.isTeacher = false})
      : super(key: key);

  @override
  State<PollContainer> createState() => _PollContainerState();
}

class _PollContainerState extends State<PollContainer> {
  late Poll? poll;
  bool isLoading = false;

  List<PollOption> options = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    await PollService.getPollByCouseId(widget.courseId!).then((value) {
      setState(() {
        poll = value;
        isLoading = true;
        options = List.generate(poll!.options!.length, (index) {
          print(poll?.results?['$index']?.length ?? 0);
          return PollOption(
              id: index,
              title: Text(poll!.options![index]),
              votes: poll?.results?['$index']?.length ?? 0);
        });
      });
    });
  }

  Future<bool> onVoted(PollOption pollOption) async {
    await PollService.votePoll(
        widget.courseId!, widget.userId!, pollOption.id!);
    await fetch();
    return true;
  }

  int? get votedOption {
    if (poll == null) return null;
    if (poll!.results == null) return null;
    final resultValues = poll!.results!.values.toList();
    for (List<String> result in resultValues) {
      if (result.contains(widget.userId)) return resultValues.indexOf(result);
    }
  }

  void onDeleted() async {
    await PollService.deleteVote(widget.courseId!, widget.userId!);

    await fetch();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? Container()
        : Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber, width: 2)),
            child: Stack(
              children: [
                //if (widget.isTeacher)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return EditPollScreen(
                              courseId: widget.courseId!,
                              poll: poll!,
                            );
                          },
                        )).then((_) {
                          fetch();
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                      )),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      poll!.subject!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(poll!.content!),
                      ),
                    ),
                    FlutterPolls(
                      key: ValueKey(votedOption),
                      pollId: widget.courseId,
                      hasVoted: votedOption != null,
                      userVotedOptionId: votedOption,
                      pollOptionsSplashColor: Colors.white,
                      votedProgressColor: MoodleColors.blue.withOpacity(0.2),
                      votedBackgroundColor: Colors.grey.withOpacity(0.2),
                      leadingVotedProgessColor:
                          MoodleColors.blue.withOpacity(0.5),
                      votedCheckmark: const Icon(
                        Icons.check_circle,
                        color: Colors.black,
                        size: 18,
                      ),
                      pollTitle: Container(),
                      onVoted: ((pollOption, newTotalVotes) async {
                        return onVoted(pollOption);
                      }),
                      pollOptions: options,
                      metaWidget: Row(
                        children: [
                          const Spacer(),
                          ElevatedButton(
                            onPressed:
                                votedOption != null ? () => onDeleted() : null,
                            child: const Text(
                              "Vote Again",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: TextButton(
                //     onPressed: votedOption != null ? () => onDeleted() : null,
                //     child: Text("Vote Again"),
                //   ),
                // )
              ],
            ));
  }
}

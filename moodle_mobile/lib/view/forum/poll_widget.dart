import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:moodle_mobile/data/firebase/firestore/polls_service.dart';
import 'package:moodle_mobile/models/poll/poll.dart';
import 'package:flutter_polls/flutter_polls.dart';

class PollContainer extends StatefulWidget {
  final Poll? poll;
  final String? courseId;
  final String? userId;
  const PollContainer({Key? key, this.poll, this.courseId, this.userId})
      : super(key: key);

  @override
  State<PollContainer> createState() => _PollContainerState();
}

class _PollContainerState extends State<PollContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.poll!.subject!),
            FlutterPolls(
              pollId: widget.courseId,
              pollOptionsSplashColor: Colors.white,
              votedProgressColor: Colors.blueGrey.withOpacity(0.3),
              votedBackgroundColor: Colors.grey.withOpacity(0.2),
              votedCheckmark: Icon(
                Icons.check_circle,
                color: Colors.black,
                size: 18,
              ),
              pollTitle: Text(widget.poll!.content!),
              onVoted: ((pollOption, newTotalVotes) async {
                PollService.votePoll(
                    widget.courseId!, widget.userId!, pollOption.id!);
                return true;
              }),
              pollOptions: [
                ...List.generate(
                    widget.poll!.options!.length,
                    (index) => PollOption(
                        id: index,
                        title: Text(widget.poll!.options![index]),
                        votes: widget.poll?.results?[index]?.length ?? 0))
              ],
              metaWidget: Row(
                children: [
                  AutoSizeText(
                    widget.poll!.voteCount.toString() + ' Votes',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 6),
                  AutoSizeText(
                    '•',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

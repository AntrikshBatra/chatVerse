import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/common_used/widgets/loader.dart';
import 'package:whatsapp_clone/models/status_model.dart';

class StatusStoryScreen extends StatefulWidget {
  static const String route = '/storyStatusScreen';
  final Status status;
  const StatusStoryScreen({super.key, required this.status});

  @override
  State<StatusStoryScreen> createState() => _StatusStoryScreenState();
}

class _StatusStoryScreenState extends State<StatusStoryScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStoryItems();
  }

  void initStoryItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(StoryItem.pageImage(
          url: widget.status.photoUrl[i], controller: controller));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}

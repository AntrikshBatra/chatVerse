import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common_used/enum/message_typpe.dart';
import 'package:whatsapp_clone/common_used/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common_used/utils.dart';
import 'package:whatsapp_clone/features/chat/controller/chatController.dart';
import 'package:whatsapp_clone/features/chat/widgets/message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserID;
  final bool isGroupChat;
  const BottomChatField(
      {super.key, required this.receiverUserID, required this.isGroupChat});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool showSendButton = false;
  bool showEmojiContainer = false;
  bool recorderinitialized = false;
  bool isRecording = false;
  FlutterSoundRecorder? _soundRecorder;
  FocusNode focus = FocusNode();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission not Allowed');
    }
    await _soundRecorder!.openRecorder();
    recorderinitialized = true;
  }

  void SendTextMessage() async {
    if (showSendButton) {
      ref.read(ChatControllerProvider).sendTextMessage(
          context,
          _messageController.text.trim(),
          widget.receiverUserID,
          widget.isGroupChat);
      setState(() {
        _messageController.text = '';
      });
      print(showSendButton.toString());
    } else {
      var tempDirectory = await getTemporaryDirectory();
      var path = '${tempDirectory.path}/flutter_sound';
      if (!recorderinitialized) {
        print('no recording........');
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageTypeEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
        print('started');
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.read(ChatControllerProvider).sendGIFMessage(
          context, gif.url, widget.receiverUserID, widget.isGroupChat);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      showEmojiContainer = false;
    });
  }

  void seeEmojiContainer() {
    setState(() {
      showEmojiContainer = true;
    });
  }

  void toggleKeyboard() {
    if (showEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      seeEmojiContainer();
    }
  }

  void showKeyboard() {
    focus.requestFocus();
  }

  void hideKeyboard() {
    focus.unfocus();
  }

  void sendFileMessage(File file, MessageTypeEnum typeEnum) {
    ref.read(ChatControllerProvider).sendFileMessage(
        context, file, widget.receiverUserID, typeEnum, widget.isGroupChat);
  }

  void selectImage() async {
    File? image = await pickImage(context);
    if (image != null) {
      sendFileMessage(image, MessageTypeEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideo(context);
    if (video != null) {
      sendFileMessage(video, MessageTypeEnum.video);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    recorderinitialized = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focus,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      showSendButton = true;
                    });
                  } else {
                    setState(() {
                      showSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                    fillColor: mobileChatBoxColor,
                    filled: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: toggleKeyboard,
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                              onPressed: selectGIF,
                              icon: const Icon(
                                Icons.gif,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: selectImage,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                            onPressed: selectVideo,
                          ),
                        ],
                      ),
                    ),
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none)),
                    contentPadding: const EdgeInsets.all(15)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2, right: 2, left: 6),
              child: CircleAvatar(
                backgroundColor: Color(0xFF128C7E),
                radius: 28,
                child: GestureDetector(
                  onTap: SendTextMessage,
                  child: Icon(
                    showSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
        showEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });

                    if (!showSendButton) {
                      setState(() {
                        showSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}

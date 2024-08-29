enum MessageTypeEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  gif('gif');

  const MessageTypeEnum(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessageTypeEnum toEnum() {
    switch (this) {
      case 'audio':
        return MessageTypeEnum.audio;
      case 'image':
        return MessageTypeEnum.image;
      case 'text':
        return MessageTypeEnum.text;
      case 'audio':
        return MessageTypeEnum.audio;
      case 'video':
        return MessageTypeEnum.video;
      case 'gif':
        return MessageTypeEnum.gif;
      default:
        return MessageTypeEnum.text;
    }
  }
}

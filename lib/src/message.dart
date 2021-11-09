import 'dart:typed_data';

import 'messages_prototypes.dart';

abstract class Message {
  const Message();

  /// encode `message` into bytes `Uint8List`
  ///
  /// if no `IMessagePrototype` defined for the `message` type an error will be thrown
  static Uint8List encode(Message message) {
    final bytes = MessagesPrototypes.instance.encodeMessage(message);
    if (bytes == null) {
      throw Exception(
        'No prototype found for message of type ${message.runtimeType}',
      );
    }
    return bytes;
  }

  /// try to decode `bytes` into a `Message` object but only if the `bytes` are a valid message
  ///
  /// also if no `IMessagePrototype` defined for the `message` type will return `null`
  static T? decode<T extends Message>(Uint8List bytes) =>
      MessagesPrototypes.instance.decodeBytes(bytes) as T?;
}

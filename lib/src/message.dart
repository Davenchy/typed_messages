import 'dart:typed_data';

import 'message_prototype.dart';
import 'messages_prototypes.dart';

abstract class Message {
  const Message();

  /// encode `message` into bytes `Uint8List`
  ///
  /// if no `IMessagePrototype` defined for the `message` type an error will be thrown
  static Uint8List encode<T extends Message>(T message) {
    final bytes = MessagesPrototypes.instance.encodeMessage(message);
    if (bytes == null) {
      throw Exception(
        'No prototype found for message of type ${message.runtimeType}',
      );
    }
    return bytes;
  }

  /// check if a [IMessagePrototype]  is defined for the `message` type [T]
  static bool hasPrototype<T extends Message>() {
    return MessagesPrototypes.instance.findPrototypeByMessageType<T>() != null;
  }

  /// define a new [prototype] for message of type [T]
  ///
  /// if [prototype] is already defined, it will be replaced
  static void define<T extends Message>(IMessagePrototype<T> prototype) {
    MessagesPrototypes.instance.definePrototype(prototype);
  }

  /// try to decode `bytes` into a `Message` object but only if the `bytes` are a valid message
  ///
  /// also if no `IMessagePrototype` defined for the `message` type will return `null`
  static T? decode<T extends Message>(Uint8List bytes) =>
      MessagesPrototypes.instance.decodeBytes(bytes) as T?;
}

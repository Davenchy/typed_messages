import 'dart:typed_data';

import 'message.dart';
import 'messages_prototypes.dart';

abstract class IMessagePrototype<T extends Message> {
  const IMessagePrototype();

  /// convert `message` object into `Uint8List`
  Uint8List encode(T message);

  /// convert `bytes` into `Message` object
  ///
  /// call `validate` before `decode` to ensure that `bytes` are valid
  /// else error could be thrown due to failure of decoding
  T decode(Uint8List bytes);

  /// validate `bytes` to ensure that they are valid and will decode without any problem
  bool validate(Uint8List bytes);

  /// define new `prototype` for `Message` type in the __MessagesPrototypes__
  ///
  /// check __MessagesPrototypes__ for more information
  static void definePrototype<T extends Message>(
    IMessagePrototype<T> prototype,
  ) =>
      MessagesPrototypes.instance.definePrototype<T>(prototype);
}

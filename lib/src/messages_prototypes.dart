import 'dart:typed_data';

import 'message.dart';
import 'message_prototype.dart';

class MessagesPrototypes {
  static MessagesPrototypes? _instance;

  /// get instance of **MessagesPrototypes**
  static MessagesPrototypes get instance {
    _instance ??= MessagesPrototypes();
    return _instance!;
  }

  final List<IMessagePrototype> _prototypes = [];

  /// define new `prototype` for message of type `T`
  ///
  /// if a `prototype` of message of type `T` is already defined, it will be replaced
  void definePrototype<T extends Message>(
    IMessagePrototype<T> prototype,
  ) =>
      _prototypes.add(prototype);

  /// find `prototype` that can handle `data`
  ///
  /// returns `null` if no `prototype` can handle `data`
  IMessagePrototype? findPrototype(Uint8List data) {
    for (var prototype in _prototypes) {
      if (prototype.validate(data)) return prototype;
    }
  }

  /// find `prototype` that defined for message type `T`
  ///
  /// returns `null` if no `prototype` had been defined
  IMessagePrototype<T>? findPrototypeByMessageType<T extends Message>() {
    for (var prototype in _prototypes) {
      if (prototype is IMessagePrototype<T>) return prototype;
    }
  }

  /// try to encode `message` of type `T`
  ///
  /// returns `null` if no `prototype` had been defined
  Uint8List? encodeMessage<T extends Message>(T message) {
    var prototype = findPrototypeByMessageType<T>();
    if (prototype == null) return null;
    return prototype.encode(message);
  }

  /// try to decode `bytes` into `Message` object
  ///
  /// returns `null` if no `prototype` had been defined
  Message? decodeBytes(Uint8List bytes) {
    var prototype = findPrototype(bytes);
    if (prototype == null) return null;
    return prototype.decode(bytes);
  }

  /// try to decode `bytes` into `Message` object of type `T`
  ///
  /// returns `null` if no `prototype` had been defined for type `T`
  /// and if `bytes` are not valid
  T? decodeBytesUsingPrototype<T extends Message>(Uint8List bytes) {
    final prototype = findPrototypeByMessageType<T>();
    if (prototype == null && (prototype?.validate(bytes) ?? false)) return null;
    return prototype!.decode(bytes);
  }
}

import 'dart:typed_data';

import 'package:typed_messages/typed_messages.dart';

const int kClientInfoMessageId = 0;

class ClientInfoMessage extends Message {
  const ClientInfoMessage(this.name, this.avatar, this.clientId)
      : assert(
          name.length >= 0 && name.length <= 20,
          'name length must be in range [0, 20] character',
        );

  final String name;
  final int avatar;
  final int clientId;
}

class ClientInfoMessagePrototype
    implements IMessagePrototype<ClientInfoMessage> {
  const ClientInfoMessagePrototype();

  @override
  Uint8List encode(ClientInfoMessage message) {
    final writer = BytesWriter(22 + message.name.length);
    writer.writeSingleByte(kClientInfoMessageId);
    writer.writeSingleByte(message.name.length);
    writer.writeText(message.name);
    writer.writeUint(message.avatar, 2);
    writer.writeUint(message.clientId, 20);
    return writer.toBuffer();
  }

  @override
  ClientInfoMessage decode(Uint8List bytes) {
    final reader = BytesReader(bytes);
    final int nameLength = reader.readSingleByte(1);
    final String name = reader.readText(2, nameLength);
    final int avatar = reader.readUint(2 + nameLength, 2);
    final int clientId = reader.readUint(4 + nameLength, 20);
    return ClientInfoMessage(name, avatar, clientId);
  }

  @override
  bool validate(Uint8List bytes) {
    final reader = BytesReader(bytes);
    if (reader.length < 22 || reader.length > 42) return false;
    final int id = reader.readSingleByte(0);
    final int nameLength = reader.readSingleByte(1);
    return id == kClientInfoMessageId && nameLength >= 0 && nameLength <= 20;
  }
}

void main() {
  IMessagePrototype.definePrototype(const ClientInfoMessagePrototype());

  final message = ClientInfoMessage("My Client", 0, 568978596);
  Uint8List bytes;
  ClientInfoMessage? decodedMessage;

  // encode
  bytes = Message.encode(message);

  // decode
  decodedMessage = Message.decode<ClientInfoMessage>(bytes);

  // ================== //
  final instance = MessagesPrototypes.instance;
  final IMessagePrototype<ClientInfoMessage>? prototype =
      instance.findPrototypeByMessageType<ClientInfoMessage>();

  bytes = prototype!.encode(message);
  final bool isValidBytes = prototype.validate(bytes);
  decodedMessage = prototype.decode(bytes);
}

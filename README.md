# TypedMessages

A simple piece of data with encoder and decoder

## Messages

Message is a piece of information can be shared between node and peer

Lets define a message

```dart
class ClientInfoMessage extends Message {
  const ClientInfoMessage(this.name, this.avatar, this.clientId)
      : assert(
          name.length <= 20,
          'client info name can not exceed 20bytes : ${name.length}',
        );

  final int clientId; // 20 bytes Uint
  final String name; // bytes length in range [0, 20]
  final int avatar; // 2 bytes Uint
}
```

## Prototypes

Prototypes are used to encode messages before send also validate and decode incoming messages

```dart
const int kClientInfoMessageId = 0;

// define or assign the prototype into the __MessagesPrototypes__ singleton
IMessagePrototype.definePrototype(const ClientInfoMessagePrototype());

class ClientInfoMessagePrototype implements IMessagePrototype<ClientInfoMessage> {
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
    final int id = reader.readUint(4 + nameLength, 20);
    return ClientInfoMessage(name, avatar, id);
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

```

## BytesWriter / BytesReader

BytesWriter and BytesReader are util classes

## Usage

Now after creating __ClientInfoMessage__ class and defining its prototype __ClientInfoMessagePrototype__ using __IMessagePrototype.defineProtoype__

We have 2 ways to encode and decode data

### Method1 __Message__ abstract class

```dart
final message = ClientInfoMessage("My Client", 0, 568978596);

final Uint8List bytes = Message.encode(message);

final ClientInfoMessage? decodedMessage = Message.decode(bytes);
```

`final ClientInfoMessage? message = Message.decode(bytes)`;

### Method2 using __MessagesPrototypes__ singleton and prototypes directly

```dart
final instance = MessagesPrototypes.instance;
final message = ClientInfoMessage("My Client", 0, 568978596);

// encode
final Uint8List? bytes = instance.encodeMessage(message);

// decode
final ClientInfoMessage? decodedMessage = instance.decodeBytes(bytes!);

// use defined prototype
final IMessagePrototype<ClientInfoMessage>? prototype = instance.findPrototypeByMessageType<ClientInfoMessage>();

prototype.encode(message);
prototype.decode(bytes!);
prototype.validate(bytes!);
```

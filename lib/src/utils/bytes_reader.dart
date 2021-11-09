import 'dart:typed_data';

class BytesReader {
  const BytesReader(this.bytes);
  final Uint8List bytes;

  int get length => bytes.length;

  /// read int at `offset` of specified `byteLength`
  int readUint(int offset, int byteLength) {
    final int end = offset + byteLength;
    if (end > bytes.length) throw Exception('Out of bounds');

    int value = 0;
    for (int i = offset; i < end; i++) {
      value = (value << 8) | bytes[i];
    }

    return value;
  }

  /// read single byte at `offset`
  int readSingleByte(int offset) => readBytes(offset, 1)[0];

  /// read bytes list from `offset` of specified `byteLength`
  Uint8List readBytes(int offset, int byteLength) {
    final int end = offset + byteLength;
    if (end > this.bytes.length) throw Exception('Out of bounds');
    final List<int> bytes = this.bytes.sublist(offset, end);
    return Uint8List.fromList(bytes);
  }

  /// read text from `offset` of specified `byteLength`
  String readText(int offset, int byteLength) {
    final Uint8List stringBytes = readBytes(offset, byteLength);
    final String value = String.fromCharCodes(stringBytes);
    return value;
  }

  /// extract as `Uint8List`
  Uint8List toBuffer() => Uint8List.fromList(bytes);

  /// extract as `ByteData`
  ByteData toByteData() => toBuffer().buffer.asByteData();
}

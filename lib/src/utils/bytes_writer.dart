import 'dart:typed_data';

class BytesWriter {
  BytesWriter(int length) : _buffer = Uint8List(length);

  final Uint8List _buffer;
  int _offset = 0;

  /// current written bytes length
  int get byteLength => _buffer.length;

  /// current offset
  int get offset => _offset;

  /// set offset
  void setOffset(int offset) {
    assert(
      offset >= 0 && offset < _buffer.length,
      'offset must be in range [0, ${_buffer.length - 1}]',
    );
    _offset = offset;
  }

  void writeSingleByte(int value) {
    _buffer[_offset++] = value;
  }

  void writeBytes(Uint8List value) {
    _buffer.setRange(_offset, _offset + value.length, value);
    _offset += value.length;
  }

  /// write `value` as Uint of `byteLength`
  void writeUint(int value, int byteLength) {
    for (int i = 0; i < byteLength; i++) {
      _buffer[_offset++] = (value >> (i * 8)) & 0xFF;
    }
  }

  void writeText(String text) {
    final textBytes = Uint8List.fromList(text.codeUnits);
    writeBytes(textBytes);
  }

  Uint8List toBuffer() => _buffer;
  ByteData toByteData() => ByteData.view(_buffer.buffer);
}

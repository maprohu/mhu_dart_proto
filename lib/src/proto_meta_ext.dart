import 'package:protobuf/protobuf.dart';

import 'proto_meta.dart';

extension PmFullFieldX<T, V> on PmFullField<T, V> {
  V? getOpt(T message) =>
      has(message) ? get(message) : null;

  void setOpt(T message, V? value) {
    if (value == null) {
      clear(message);
    } else {
      set(message, value);
    }
  }

  void ensureDefault(
    T message,
    V Function() defaultValue,
  ) {
    if (!has(message)) {
      set(message, defaultValue());
    }
  }
}

extension PmFullFieldProtoX<T extends GeneratedMessage, V>
    on PmFullField<T, V> {
  T ensureProtoDefault(
    T message,
    V Function() defaultValue,
  ) =>
      message.rebuild(
        (b) => ensureDefault(b, defaultValue),
      );
}

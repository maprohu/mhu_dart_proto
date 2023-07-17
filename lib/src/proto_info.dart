import 'package:mhu_dart_commons/commons.dart';
import 'package:protobuf/protobuf.dart';




abstract class Message<T> implements HasName {}

abstract class Field<T> implements HasName {
  Message<T> get parent;
}

abstract class TypedField<T, V> implements Field<T> {
  V get(T message);
}

abstract class SingleField<T, V> implements TypedField<T, V> {
  void set(T message, V value);

  bool has(T message);

  void clear(T message);
}

extension SingleFieldX<T, V> on SingleField<T, V> {

  V? opt(T parent) => has(parent) ? get(parent) : null;

  void update(T parent, V? optValue) {
    if (optValue == null) {
      clear(parent);
    } else {
      set(parent, optValue);
    }
  }
}

abstract class MessageField<T, V> implements SingleField<T, V> {
  V ensure(T message);
}

abstract class MapField<T, K, V> implements TypedField<T, Map<K, V>> {
  V? getItem(T parent, K key) => get(parent)[key];
}

abstract class MessageMapField<T, K, V extends GeneratedMessage>
    implements MapField<T, K, V> {
  void update(
    T t,
    K key,
    void Function(V value) updates,
  ) {
    final map = get(t);
    if (map.containsKey(key)) {
      final old = map[key] as V;
      map[key] = old.rebuild(updates);
    }
  }
}

abstract class RepeatedField<T, V> implements TypedField<T, List<V>> {}


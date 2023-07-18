import 'package:mhu_dart_commons/commons.dart';
import 'package:protobuf/protobuf.dart';
import 'package:rxdart/rxdart.dart';

extension PrototGeneratedMessageX<T extends GeneratedMessage> on T {
  T deepUpdate(void Function(T message) updater) =>
      deepCopy().also(updater)..freeze();

  V get<V>(FieldInfo<V> info) {
    if (info.isMapField) {
      return $_getMap(info.index!) as V;
    } else {
      return getField(info.tagNumber) as V;
    }
  }

  void set<V extends Object>(FieldInfo<V?> info, V value) =>
      setField(info.tagNumber, value);

  V require<V extends Object>(FieldInfo<V?> info) => get(info)!;
}

extension ProtoBehaviorSubjectX<T extends GeneratedMessage>
    on BehaviorSubject<T> {
  void deepUpdate(void Function(T message) updater) =>
      add(value.deepUpdate(updater));
}

abstract class ProtoField<P extends GeneratedMessage, F, I extends FieldInfo<F>>
    implements HasName {
  final I info;

  int get tagNumber => info.tagNumber;

  const ProtoField(this.info);

  @override
  String get name => info.name;
}

class ProtoMap<P extends GeneratedMessage, K, V extends GeneratedMessage>
    extends ProtoField<P, Map<K, V>?, MapFieldInfo<K, V>> {
  final Map<K, V> Function(P parent) mapGetter;
  final ProtoClass<V> protoClass;

  const ProtoMap(
    super.fieldInfo,
    this.protoClass,
    this.mapGetter,
  );

  V? get(P parent, K key) => mapGetter(parent)[key];

  void update(
    P t,
    K key,
    void Function(V value) updates,
  ) {
    final map = mapGetter(t);
    if (map.containsKey(key)) {
      final old = map[key] as V;
      map[key] = old.rebuild(updates);
    }
  }
}

class ProtoScalar<P extends GeneratedMessage, V extends Object>
    extends ProtoField<P, V, FieldInfo<V>> {
  final V Function(P parent) get;
  final void Function(P parent, V value) set;
  final bool Function(P parent) has;
  final void Function(P parent) clear;

  const ProtoScalar(super.info, this.get, this.set, this.has, this.clear);

  V? opt(P parent) => has(parent) ? get(parent) : null;

  void update(P parent, V? optValue) {
    if (optValue == null) {
      clear(parent);
    } else {
      set(parent, optValue);
    }
  }
}

class ProtoClass<V extends GeneratedMessage> implements HasName {
  final V instance;

  const ProtoClass(this.instance);

  BuilderInfo get info => instance.info_;

  @override
  String get name => info.messageName;

  FieldInfo<T> field<T>(int tagNumber) =>
      info.fieldInfo[tagNumber] as FieldInfo<T>;

  MapFieldInfo<K, T> mapField<K, T>(int tagNumber) =>
      field(tagNumber) as MapFieldInfo<K, T>;
}

extension MhuProtoEnumX<T extends ProtobufEnum> on T {
  String get label => name.camelCaseToLabel;
}

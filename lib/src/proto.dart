import 'package:protobuf/protobuf.dart';

typedef Rebuilder<T> = T Function(T original, void Function(T value) updates);

T protoRebuilder<T extends GeneratedMessage>(
        T original, void Function(T value) updates) =>
    original.rebuild(updates);

T castProtoRebuilder<T>(T original, void Function(T value) updates) =>
    protoRebuilder<GeneratedMessage>(
      original as GeneratedMessage,
      (value) => updates(value as T),
    ) as T;

sealed class Cardinality<I extends FieldInfo> {
  final I fieldInfo;

  const Cardinality(this.fieldInfo);

  static Cardinality from<T>(BuilderInfo builder, FieldInfo field) {
    if (field is MapFieldInfo) {
      return MapOf(field);
    } else if (field.isRepeated) {
      return Repeated(field);
    } else if (builder.oneofs.containsKey(field.tagNumber)) {
      return OneOf(field);
    } else {
      return Single(field);
    }
  }
}

class MapOf extends Cardinality<MapFieldInfo> {
  const MapOf(super.fieldInfo);
}

abstract class NonMap extends Cardinality<FieldInfo> {
  const NonMap(super.fieldInfo);
}

class Single extends NonMap {
  const Single(super.fieldInfo);
}

class Repeated extends NonMap {
  const Repeated(super.fieldInfo);
}

class OneOf extends NonMap {
  const OneOf(super.fieldInfo);
}

sealed class ValueType {
  const ValueType();

  MessageType fromMessage(GeneratedMessage message) =>
      MessageType(message.info_);

  ValueType fromSingle(FieldInfo field) {
    try {
      if (field.isEnum) {
        return EnumType();
      }
      final value = field.makeDefault!();
      return fromValue(value);
    } catch (e) {
      print(field);
      rethrow;
    }
  }

  ValueType fromValue(Object value) {
    if (value is GeneratedMessage) {
      return MessageType(value.info_);
    } else if (value is int) {
      return IntType();
    } else if (value is bool) {
      return BoolType();
    } else if (value is String) {
      return StringType();
    }
    throw value;
  }

  ValueType fromType(Type value) {
    if (value == int) {
      return IntType();
    } else if (value == bool) {
      return BoolType();
    } else if (value == String) {
      return StringType();
    }
    throw value;
  }

  ValueType fromMapField(MapFieldInfo mapField) {
    final vc = mapField.valueCreator;
    if (vc != null) {
      return MessageType(vc().info_);
    } else {
      return fromSingle(mapField.valueFieldInfo);
    }
  }
}

class BoolType extends ValueType {
  const BoolType();
}

class IntType extends ValueType {
  const IntType();
}

class StringType extends ValueType {
  const StringType();
}

class EnumType extends ValueType {
  const EnumType();
}

class MessageType extends ValueType {
  final BuilderInfo builderInfo;

  const MessageType(this.builderInfo);
}

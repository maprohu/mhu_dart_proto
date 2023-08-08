import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_commons/commons.dart' as commons;
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

part 'pbgen.dart';

extension FieldInfoX on FieldInfo<dynamic> {
  int get singleValueType => type & _optionalTypes;

  FieldAccess<M, dynamic, dynamic> accessForMessage<M extends GeneratedMessage>(
    PbiMessage<M> msg, {
    int? type,
  }) {
    return msg
        .withGeneric<FieldAccess>(
          <T extends GeneratedMessage>(_) => access<T>(type: type),
        )
        .cast();
  }

  FieldAccess<M, dynamic, dynamic> access<M extends GeneratedMessage>({
    bool unsafe = false,
    int? type,
  }) {
    return accessForType<M>(type ?? this.type, unsafe: unsafe);
  }

  FieldAccess<M, dynamic, dynamic> accessForType<M extends GeneratedMessage>(
    int type, {
    bool unsafe = false,
  }) {
    if (!unsafe) {
      assert(M != GeneratedMessage);
    }
    RepeatedFieldAccess<M, F> repeated<F>() =>
        RepeatedFieldAccess(cast(), unsafe: unsafe);

    switch (type) {
      case PbFieldType.OD:
        return DoubleFieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.OF:
        return FloatFieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.O3:
        return Int32FieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.OU3:
      case PbFieldType.OF3:
        return Uint32FieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.OS3:
      case PbFieldType.OSF3:
        return Sint32FieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.O6:
      case PbFieldType.OU6:
      case PbFieldType.OS6:
      case PbFieldType.OF6:
      case PbFieldType.OSF6:
        return Int64FieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.OB:
        return BoolFieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.OS:
        return StringFieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.OY:
        return BytesFieldAccess(cast(), unsafe: unsafe);
      case PbFieldType.OM:
        final valueDefault = subBuilder!();
        final result = valueDefault.pbi.withGeneric<MessageFieldAccess>(
          <R extends GeneratedMessage>(_) =>
              MessageFieldAccess<M, R>(cast(), unsafe: unsafe),
        );
        return result.cast();
      case PbFieldType.OE:
        final valueDefault = enumValues!.first;
        final result = valueDefault.pbi.withEnumType(
          <R extends ProtobufEnum>() =>
              // ignore: unnecessary_cast
              EnumFieldAccess<M, R>(cast(), unsafe: unsafe) as EnumFieldAccess,
        );
        return result.cast();

      case PbFieldType.PY:
        return repeated<List<int>>();
      case PbFieldType.PS:
        return repeated<String>();
      case PbFieldType.PB:
      case PbFieldType.KB:
        return repeated<bool>();
      case PbFieldType.PF:
      case PbFieldType.KF:
      case PbFieldType.PD:
      case PbFieldType.KD:
        return repeated<double>();
      case PbFieldType.P3:
      case PbFieldType.PF3:
      case PbFieldType.PS3:
      case PbFieldType.PU3:
      case PbFieldType.PSF3:
      case PbFieldType.K3:
      case PbFieldType.KF3:
      case PbFieldType.KS3:
      case PbFieldType.KU3:
      case PbFieldType.KSF3:
        return repeated<int>();
      case PbFieldType.P6:
      case PbFieldType.PF6:
      case PbFieldType.PS6:
      case PbFieldType.PU6:
      case PbFieldType.PSF6:
      case PbFieldType.K6:
      case PbFieldType.KF6:
      case PbFieldType.KS6:
      case PbFieldType.KU6:
      case PbFieldType.KSF6:
        return repeated<Int64>();

      case PbFieldType.PE:
      case PbFieldType.KE:
        final valueDefault = enumValues!.first;
        final result = valueDefault.pbi.withEnumType(
          <R extends ProtobufEnum>() =>
              // ignore: unnecessary_cast
              repeated<R>() as RepeatedFieldAccess,
        );
        return result.cast();

      case PbFieldType.PM:
        final valueDefault = subBuilder!();
        final result = valueDefault.pbi.withGeneric<RepeatedFieldAccess>(
          <R extends GeneratedMessage>(_) => repeated<R>(),
        );
        return result.cast();

      case PbFieldType.M:
        final mapInfo = this as MapFieldInfo;
        final keyAccess =
            mapInfo.mapEntryBuilderInfo.byIndex[0].access(unsafe: true);
        final valueAccess =
            mapInfo.mapEntryBuilderInfo.byIndex[1].access(unsafe: true);

        final result = keyAccess.withValueType<MapFieldAccess>(
          <K>() => valueAccess.withValueType<MapFieldAccess>(
            <V>() => MapFieldAccess<M, K, V>(cast(), unsafe: unsafe),
          ),
        );

        return result.cast();
    }
    throw this;
  }
}

sealed class FieldKey {
  final Type messageType;

  FieldKey({
    required this.messageType,
  }) {
    assert(messageType != GeneratedMessage);
  }
}

extension FieldKeyX on FieldKey {
  String get protoName => switch (this) {
    ConcreteFieldKey(:final calc) => calc.protoName,
    OneofFieldKey(:final calc) => calc.name,
  };
}

class ConcreteFieldKey extends FieldKey {
  final int tagNumber;

  ConcreteFieldKey({
    required super.messageType,
    required this.tagNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConcreteFieldKey &&
          runtimeType == other.runtimeType &&
          messageType == other.messageType &&
          tagNumber == other.tagNumber;

  @override
  int get hashCode => messageType.hashCode ^ tagNumber.hashCode;
}

abstract class HasConcreteFieldKey {
  ConcreteFieldKey get concreteFieldKey;
}

class OneofFieldKey extends FieldKey {
  final int oneofIndex;

  OneofFieldKey({
    required super.messageType,
    required this.oneofIndex,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OneofFieldKey &&
          runtimeType == other.runtimeType &&
          messageType == other.messageType &&
          oneofIndex == other.oneofIndex;

  @override
  int get hashCode => messageType.hashCode ^ oneofIndex.hashCode;
}

abstract interface class FieldMarker<M extends GeneratedMessage> {
  FieldKey get fieldKey;
}

sealed class FieldAccess<M extends GeneratedMessage, F, S>
    implements FieldMarker<M> {
  FieldAccess({
    bool unsafe = false,
  }) {
    if (!unsafe) {
      assert(M != GeneratedMessage);
    }
  }

  FieldInfo/*<S>*/ get fieldInfo;

  F get(M message);

  Type get valueType => F;

  Type get singleValueType => S;

  R withValueType<R>(R Function<T>() fn) => fn<F>();

  R withSingleValueType<R>(R Function<T>() fn) => fn<S>();

  R withGenerics<R>(
    R Function<TM extends GeneratedMessage, TF, TS>(
      FieldAccess<TM, TF, TS> access,
    ) fn,
  ) {
    return fn(this);
  }

  S get defaultSingleValue;

  @override
  ConcreteFieldKey get fieldKey => ConcreteFieldKey(
        messageType: M,
        tagNumber: tagNumber,
      );
}

extension FieldAccessX<M extends GeneratedMessage, F, S>
    on FieldAccess<M, F, S> {
  int get tagNumber => fieldInfo.tagNumber;

  int get index => fieldInfo.index!;

  String get name => fieldInfo.name;

  Fr<F> fr(
    Fr<M> message, {
    DspReg? disposers,
  }) =>
      commons.fr(
        () => get(message()),
        disposers: disposers,
      );

  bool get isMessageValue => defaultSingleValue is GeneratedMessage;
}

sealed class ScalarFieldAccess<M extends GeneratedMessage, F>
    extends FieldAccess<M, F, F> {
  @override
  final FieldInfo fieldInfo;

  ScalarFieldAccess(
    this.fieldInfo, {
    super.unsafe,
  });

  @override
  F get(M message) => message.$_getN(index);

  void set(M message, F value);

  bool has(M message) => message.$_has(index);

  void clear(M message) {
    message.clearField(tagNumber);
  }

  R withScalarGenerics<R>(
    R Function<TM extends GeneratedMessage, TF>(
      ScalarFieldAccess<TM, TF> access,
    ) fn,
  ) {
    return fn(this);
  }

  @override
  F get defaultSingleValue => fieldInfo.makeDefault!();
}

extension ScalarFieldAccessX<M extends GeneratedMessage, F>
    on ScalarFieldAccess<M, F> {
  F? getOpt(M message) => has(message) ? get(message) : null;
  void setOpt(M message, F? value) {
    if (value == null) {
      clear(message);
    } else {
      set(message, value);
    }
  }

  Fw<F> fw(
    Fw<M> message, {
    DspReg? disposers,
  }) =>
      commons.frw(
        this.fr(message, disposers: disposers),
        (v) => setFw(message, v),
      );

  void setFw(Fw<M> fv, F value) {
    fv.rebuild(
      (message) {
        set(message, value);
      },
    );
  }

  void Function(F value) setFwFor(Fw<M> message) =>
      (value) => setFw(message, value);

  Fw<F> fieldFwHot(
    Fw<M> message, {
    required DspReg disposers,
  }) {
    return frw(
      disposers.fr(() => get(message())),
      setFwFor(message),
    );
  }

  Fw<F> fieldFw(
    Fw<M> message,
  ) {
    return frw(
      message.map(get),
      setFwFor(message),
    );
  }
}

sealed class NumericIntFieldAccess<M extends GeneratedMessage>
    extends ScalarFieldAccess<M, int> {
  NumericIntFieldAccess(
    super.fieldInfo, {
    super.unsafe,
  });
}

class Int32FieldAccess<M extends GeneratedMessage>
    extends NumericIntFieldAccess<M> {
  Int32FieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  int get(M message) => message.$_getIZ(index);

  @override
  void set(M message, int value) {
    message.$_setSignedInt32(index, value);
  }
}

class Uint32FieldAccess<M extends GeneratedMessage>
    extends NumericIntFieldAccess<M> {
  Uint32FieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  int get(M message) => message.$_getIZ(index);

  @override
  void set(M message, int value) {
    message.$_setUnsignedInt32(index, value);
  }
}

class Sint32FieldAccess<M extends GeneratedMessage>
    extends NumericIntFieldAccess<M> {
  Sint32FieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  int get(M message) => message.$_getIZ(index);

  @override
  void set(M message, int value) {
    message.$_setSignedInt32(index, value);
  }
}

class Int64FieldAccess<M extends GeneratedMessage>
    extends ScalarFieldAccess<M, Int64> {
  Int64FieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  Int64 get(M message) => message.$_getI64(index);

  @override
  void set(M message, Int64 value) {
    message.$_setInt64(index, value);
  }
}

sealed class NumericDoubleFieldAccess<M extends GeneratedMessage>
    extends ScalarFieldAccess<M, double> {
  NumericDoubleFieldAccess(
    super.fieldInfo, {
    super.unsafe,
  });
}

class DoubleFieldAccess<M extends GeneratedMessage>
    extends NumericDoubleFieldAccess<M> {
  DoubleFieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  void set(M message, double value) {
    message.$_setDouble(index, value);
  }
}

class FloatFieldAccess<M extends GeneratedMessage>
    extends NumericDoubleFieldAccess<M> {
  FloatFieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  void set(M message, double value) {
    message.$_setFloat(index, value);
  }
}

class MessageFieldAccess<M extends GeneratedMessage, F extends GeneratedMessage>
    extends ScalarFieldAccess<M, F> {
  MessageFieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  void set(M message, F value) {
    message.setField(tagNumber, value);
  }

  F ensure(M message) => message.$_ensure(index);

  @override
  F get defaultSingleValue => fieldInfo.subBuilder!() as F;
}

extension MessageFieldAccessX<M extends GeneratedMessage,
    F extends GeneratedMessage> on MessageFieldAccess<M, F> {
  PbiMessage<F> get valuePbiMessage => defaultSingleValue.pbi;
}

class EnumFieldAccess<M extends GeneratedMessage, E extends ProtobufEnum>
    extends ScalarFieldAccess<M, E> {
  EnumFieldAccess(
    super.fieldInfo, {
    super.unsafe,
  });

  @override
  void set(M message, E value) {
    message.setField(tagNumber, value);
  }
}

extension EnumFieldAccessX<M extends GeneratedMessage, E extends ProtobufEnum>
    on EnumFieldAccess<M, E> {
  List<E> get enumValues => fieldInfo.enumValues! as List<E>;
}

class BoolFieldAccess<M extends GeneratedMessage>
    extends ScalarFieldAccess<M, bool> {
  BoolFieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  bool get(M message) => message.$_getBF(index);

  @override
  void set(M message, bool value) {
    message.$_setBool(index, value);
  }
}

class StringFieldAccess<M extends GeneratedMessage>
    extends ScalarFieldAccess<M, String> {
  StringFieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  String get(M message) => message.$_getSZ(index);

  @override
  void set(M message, String value) {
    message.$_setString(index, value);
  }
}

class BytesFieldAccess<M extends GeneratedMessage>
    extends ScalarFieldAccess<M, List<int>> {
  BytesFieldAccess(
    super.fieldRef, {
    super.unsafe,
  });

  @override
  void set(M message, List<int> value) {
    message.$_setBytes(index, value);
  }
}

const _optionalTypes = PbFieldType.OB |
    PbFieldType.OY |
    PbFieldType.OS |
    PbFieldType.OF |
    PbFieldType.OD |
    PbFieldType.OE |
    PbFieldType.OG |
    PbFieldType.O3 |
    PbFieldType.O6 |
    PbFieldType.OS3 |
    PbFieldType.OS6 |
    PbFieldType.OU3 |
    PbFieldType.OU6 |
    PbFieldType.OF3 |
    PbFieldType.OF6 |
    PbFieldType.OSF3 |
    PbFieldType.OSF6 |
    PbFieldType.OM;

class RepeatedFieldAccess<M extends GeneratedMessage, F>
    extends FieldAccess<M, List<F>, F> {
  @override
  final FieldInfo fieldInfo;

  RepeatedFieldAccess(
    this.fieldInfo, {
    super.unsafe,
  });

  @override
  List<F> get(M message) => message.$_getList(index);

  @override
  F get defaultSingleValue {
    final maker = FieldInfo.findMakeDefault(
      fieldInfo.type & _optionalTypes,
      fieldInfo.subBuilder ?? fieldInfo.defaultEnumValue,
    );
    return maker!();
  }

  R withListGenerics<R>(
    R Function<TM extends GeneratedMessage, TF>(
      RepeatedFieldAccess<TM, TF> access,
    ) fn,
  ) {
    return fn(this);
  }
}

extension RepeatedFieldAccessX<M extends GeneratedMessage, F>
    on RepeatedFieldAccess<M, F> {
  Fu<List<F>> fuHot(
    Fw<M> message, {
    DspReg? disposers,
  }) {
    return commons.fuHot(
      message,
      get,
      disposers: disposers,
    );
  }
}

class MapFieldAccess<M extends GeneratedMessage, K, V>
    extends FieldAccess<M, Map<K, V>, V> {
  @override
  final MapFieldInfo fieldInfo;

  Type get keyType => K;

  MapFieldAccess(
    this.fieldInfo, {
    super.unsafe,
  });

  @override
  V get defaultSingleValue {
    final valueField = fieldInfo.valueFieldInfo;
    final fn = valueField.makeDefault ??
        valueField.subBuilder ??
        valueField.enumValues?.let((ev) => () => ev.first) ??
        (throw fieldInfo.name);
    return fn();
  }

  @override
  Map<K, V> get(M message) => message.$_getMap(index);

  R withMapGenerics<R>(
    R Function<TM extends GeneratedMessage, TK, TV>(
      MapFieldAccess<TM, TK, TV> access,
    ) fn,
  ) {
    return fn(this);
  }
}

abstract class HasMapFieldAccess<M extends GeneratedMessage, K, V> {
  MapFieldAccess<M, K, V> get mapFieldAccess;
}

extension MapFieldAccessX<M extends GeneratedMessage, K, V>
    on MapFieldAccess<M, K, V> {
  PbMapKey get defaultMapKey => switch (keyType) {
        int => PbMapKey.defaultInt,
        String => PbMapKey.defaultString,
        final other => throw other,
      };

  Fu<Map<K, V>> fuHot(
      Fw<M> message, {
        DspReg? disposers,
      }) {
    return commons.fuHot(
      message,
      get,
      disposers: disposers,
    );
  }
  Fu<Map<K, V>> fuCold(
    Fw<M> message, ) {
    return commons.fuCold(
      message,
      get,
    );
  }
}

List<FieldInfo> listOneofFields({
  required BuilderInfo builderInfo,
  required int oneofIndex,
}) {
  return builderInfo.sortedByTag
      .where((f) => builderInfo.oneofs[f.tagNumber] == oneofIndex)
      .toList();
}

class PbiOneofLookup<E extends Enum> {
  final Map<int, E> tagToWhich;
  final Map<E, int> whichToTag;

  const PbiOneofLookup({
    required this.tagToWhich,
    required this.whichToTag,
  });
}

PbiOneofLookup<E> createOneofLookup<E extends Enum>({
  required BuilderInfo builderInfo,
  required int oneofIndex,
  required List<E> options,
}) {
  final entries = listOneofFields(
    builderInfo: builderInfo,
    oneofIndex: oneofIndex,
  ).mapIndexed(
    (index, field) => MapEntry(
      field.tagNumber,
      options[index],
    ),
  );
  final tagToWhich = {
    ...Map.fromEntries(entries),
    0: options.last,
  };

  final whichToTag = tagToWhich.map(
    (key, value) => MapEntry(value, key),
  );

  return PbiOneofLookup(
    tagToWhich: tagToWhich,
    whichToTag: whichToTag,
  );
}

class OneofFieldAccess<M extends GeneratedMessage, E extends Enum>
    implements FieldMarker<M> {
  final int oneofIndex;

  final Map<int, E> _tagToWhich;

  OneofFieldAccess({
    required this.oneofIndex,
    required BuilderInfo builderInfo,
    required List<E> options,
  }) : _tagToWhich = createOneofLookup(
          oneofIndex: oneofIndex,
          builderInfo: builderInfo,
          options: options,
        ).tagToWhich;

  E which(M message) => _tagToWhich[message.$_whichOneof(oneofIndex)]!;

  void clear(M message) {
    message.clearField(
      message.$_whichOneof(oneofIndex),
    );
  }

  @override
  FieldKey get fieldKey => OneofFieldKey(
        messageType: M,
        oneofIndex: oneofIndex,
      );
}

import 'package:fixnum/fixnum.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

part 'data_type.g.has.dart';

part 'data_type.g.compose.dart';

typedef GenericFunction1<T> = R Function<R>(R Function<TT extends T>() fn);

GenericFunction1<B> genericFunction1<B, T extends B>() => <R>(fn) => fn<T>();

@Has()
typedef DataTypeGeneric<T> = GenericFunction1<T>;

@Has()
typedef DefaultValue<T> = T;

@Has()
typedef ReadFieldValue<F> = F Function(
  GeneratedMessage message,
  int fieldIndex,
);

ReadFieldValue<F> _getN<F>() {
  return (message, fieldIndex) => message.$_getN(fieldIndex);
}

ReadFieldValue<int> _getIZ() {
  return (message, fieldIndex) => message.$_getIZ(fieldIndex);
}

ReadFieldValue<Int64> _getI64() {
  return (message, fieldIndex) => message.$_getI64(fieldIndex);
}

ReadFieldValue<bool> _getBF() {
  return (message, fieldIndex) => message.$_getBF(fieldIndex);
}

ReadFieldValue<String> _getSZ() {
  return (message, fieldIndex) => message.$_getSZ(fieldIndex);
}

ReadFieldValue<List<F>> _getList<F>() {
  return (message, fieldIndex) => message.$_getList(fieldIndex);
}

ReadFieldValue<Map<K, V>> _getMap<K, V>() {
  return (message, fieldIndex) => message.$_getMap(fieldIndex);
}

extension HasReadFieldValueX<F> on HasReadFieldValue<F> {
  F Function(M message) readFieldValueFor<M extends GeneratedMessage>(
    int fieldIndex,
  ) {
    return (message) => readFieldValue(message, fieldIndex);
  }
}

@Compose()
abstract class DataTypeBits<T>
    implements HasDataTypeGeneric, HasReadFieldValue<T>, HasDefaultValue<T> {
  static DataTypeBits<T> of<T>({
    required ReadFieldValue<T> readFieldValue,
    required T defaultValue,
  }) =>
      ComposedDataTypeBits<T>(
        dataTypeGeneric: genericFunction1<dynamic, T>(),
        readFieldValue: readFieldValue,
        defaultValue: defaultValue,
      );
}

sealed class DataType<T> implements DataTypeBits<T> {
  static ScalarDataType? _scalar({
    required FieldInfo fieldInfo,
    int? fieldInfoType,
  }) {
    fieldInfoType ??= fieldInfo.type;

    switch (fieldInfoType) {
      case PbFieldType.OD:
        return DoubleDataType.instance;
      case PbFieldType.OF:
        return FloatDataType.instance;
      case PbFieldType.O3:
        return Int32DataType.instance;
      case PbFieldType.OU3:
      case PbFieldType.OF3:
        return Uint32DataType.instance;
      case PbFieldType.OS3:
      case PbFieldType.OSF3:
        return Sint32DataType.instance;
      case PbFieldType.O6:
      case PbFieldType.OU6:
      case PbFieldType.OS6:
      case PbFieldType.OF6:
      case PbFieldType.OSF6:
        return Int64DataType.instance;
      case PbFieldType.OB:
        return BoolDataType.instance;
      case PbFieldType.OS:
        return StringDataType.instance;
      case PbFieldType.OY:
        return BytesDataType.instance;
      case PbFieldType.OM:
        return MessageDataType.of(fieldInfo: fieldInfo);
      case PbFieldType.OE:
        return EnumDataType.of(fieldInfo: fieldInfo);
      default:
        return null;
    }
  }

  static const int _repeatedBit = 0x2;
  static const int _packedBit = 0x4;
  static const int _repeatedOrPackedBits = _repeatedBit | _packedBit;

  static DataType of({
    required FieldInfo fieldInfo,
  }) {
    final fieldInfoType = fieldInfo.type;

    final isRepeated = fieldInfoType & _repeatedOrPackedBits != 0;

    if (isRepeated) {
      return RepeatedDataType.of(
        repeatedItemDataType: _scalar(
          fieldInfo: fieldInfo,
          fieldInfoType: fieldInfoType & ~_repeatedOrPackedBits,
        )!,
      );
    }

    if (fieldInfoType == PbFieldType.M) {
      final mapInfo = fieldInfo as MapFieldInfo;
      final keyInfo = mapInfo.mapEntryBuilderInfo.byIndex[0];
      final valueInfo = mapInfo.mapEntryBuilderInfo.byIndex[1];

      final mapKeyDataType = _scalar(fieldInfo: keyInfo) as MapKeyDataType;
      final mapValueDataType =
          _scalar(fieldInfo: valueInfo) as MapValueDataType;

      return mapKeyDataType.dataTypeGeneric(
        <KR>() {
          return mapValueDataType.dataTypeGeneric(
            <VR>() {
              return MapDataType.of(
                mapKeyDataType: mapKeyDataType as MapKeyDataType<KR>,
                mapValueDataType: mapValueDataType as MapValueDataType<VR>,
              );
            },
          );
        },
      );
    }

    return _scalar(fieldInfo: fieldInfo)!;
  }
}

sealed class ScalarDataType<T> implements DataType<T> {}

@Compose()
abstract class BytesDataType extends ScalarDataType<List<int>>
    implements DataTypeBits<List<int>> {
  static final instance = ComposedBytesDataType.dataTypeBits(
    dataTypeBits: DataTypeBits.of(
      readFieldValue: _getN(),
      defaultValue: const [],
    ),
  );
}

@Compose()
abstract class MessageDataType<M extends GeneratedMessage>
    implements DataTypeBits<M>, ScalarDataType<M> {
  static MessageDataType of({
    required FieldInfo fieldInfo,
  }) {
    final GeneratedMessage defaultValue = fieldInfo.makeDefault!();
    return defaultValue.pbi.withGeneric(
      <R extends GeneratedMessage>(_) {
        return ComposedMessageDataType<R>.dataTypeBits(
          dataTypeBits: DataTypeBits.of(
            readFieldValue: _getN(),
            defaultValue: defaultValue as R,
          ),
        );
      },
    );
  }
}

@Compose()
abstract class Int64DataType
    implements
        DataTypeBits<Int64>,
        ScalarDataType<Int64>,
        MapKeyDataType<Int64> {
  static final instance = ComposedInt64DataType.dataTypeBits(
    dataTypeBits: DataTypeBits.of(
      readFieldValue: _getI64(),
      defaultValue: Int64.ZERO,
    ),
    mapKeyComparator: (a, b) => a.compareTo(b),
  );
}

@Compose()
abstract class EnumDataType<E extends ProtobufEnum>
    implements DataTypeBits<E>, ScalarDataType<E> {
  static EnumDataType of({
    required FieldInfo fieldInfo,
  }) {
    final defaultValue = fieldInfo.enumValues!.first;
    return defaultValue.pbi.withEnumType(
      <R extends ProtobufEnum>() {
        return ComposedEnumDataType<R>.dataTypeBits(
          dataTypeBits: DataTypeBits.of(
            readFieldValue: _getN(),
            defaultValue: defaultValue as R,
          ),
        );
      },
    );
  }
}

@Compose()
abstract class BoolDataType
    implements DataTypeBits<bool>, ScalarDataType<bool>, MapKeyDataType<bool> {
  static final instance = ComposedBoolDataType.dataTypeBits(
    dataTypeBits: DataTypeBits.of(
      readFieldValue: _getBF(),
      defaultValue: false,
    ),
    mapKeyComparator: (a, b) => (a == b ? 0 : (a ? 1 : -1)),
  );
}

@Compose()
abstract class StringDataType
    implements
        DataTypeBits<String>,
        ScalarDataType<String>,
        MapKeyDataType<String> {
  static final instance = ComposedStringDataType.dataTypeBits(
    dataTypeBits: DataTypeBits.of(
      readFieldValue: _getSZ(),
      defaultValue: "",
    ),
    mapKeyComparator: (a, b) => a.compareTo(b),
  );
}

@Compose()
abstract class CoreIntDataTypeBits
    implements DataTypeBits<int>, HasMapKeyComparator<int> {
  static final instance = ComposedCoreIntDataTypeBits.dataTypeBits(
    dataTypeBits: DataTypeBits.of(
      readFieldValue: _getIZ(),
      defaultValue: 0,
    ),
    mapKeyComparator: (a, b) => a.compareTo(b),
  );
}

sealed class CoreIntDataType
    implements ScalarDataType<int>, MapKeyDataType<int> {}

@Compose()
abstract class Int32DataType implements CoreIntDataType, CoreIntDataTypeBits {
  static final instance = ComposedInt32DataType.coreIntDataTypeBits(
    coreIntDataTypeBits: CoreIntDataTypeBits.instance,
  );
}

@Compose()
abstract class Uint32DataType implements CoreIntDataType, CoreIntDataTypeBits {
  static final instance = ComposedUint32DataType.coreIntDataTypeBits(
    coreIntDataTypeBits: CoreIntDataTypeBits.instance,
  );
}

@Compose()
abstract class Sint32DataType implements CoreIntDataType, CoreIntDataTypeBits {
  static final instance = ComposedSint32DataType.coreIntDataTypeBits(
    coreIntDataTypeBits: CoreIntDataTypeBits.instance,
  );
}

@Compose()
abstract class CoreDoubleDataTypeBits implements DataTypeBits<double> {
  static final instance = ComposedCoreDoubleDataTypeBits.dataTypeBits(
    dataTypeBits: DataTypeBits.of(
      readFieldValue: _getN(),
      defaultValue: 0.0,
    ),
  );
}

sealed class CoreDoubleDataType implements ScalarDataType<double> {}

@Compose()
abstract class FloatDataType
    implements CoreDoubleDataType, CoreDoubleDataTypeBits {
  static final instance = ComposedFloatDataType.coreDoubleDataTypeBits(
    coreDoubleDataTypeBits: CoreDoubleDataTypeBits.instance,
  );
}

@Compose()
abstract class DoubleDataType
    implements CoreDoubleDataType, CoreDoubleDataTypeBits {
  static final instance = ComposedDoubleDataType.coreDoubleDataTypeBits(
    coreDoubleDataTypeBits: CoreDoubleDataTypeBits.instance,
  );
}

@Has()
sealed class MapKeyDataType<K>
    implements HasMapKeyComparator<K>, DataTypeBits<K> {}

@Has()
typedef MapValueDataType<V> = ScalarDataType<V>;

@Has()
typedef MapKeyComparator<K> = Comparator<K>;

@Compose()
@Has()
abstract class MapDataType<K, V>
    implements
        DataTypeBits<Map<K, V>>,
        DataType<Map<K, V>>,
        HasMapKeyDataType<K>,
        HasMapValueDataType<V> {
  static MapDataType<K, V> of<K, V>({
    required MapKeyDataType<K> mapKeyDataType,
    required MapValueDataType<V> mapValueDataType,
  }) {
    return ComposedMapDataType.dataTypeBits(
      dataTypeBits: DataTypeBits.of(
        readFieldValue: _getMap(),
        defaultValue: const {},
      ),
      mapKeyDataType: mapKeyDataType,
      mapValueDataType: mapValueDataType,
    );
  }
}

extension MapDataTypeX<K, V> on MapDataType<K, V> {
  R mapKeyValueGeneric<R>(
      R Function<KK, VV>(MapDataType<KK, VV> mapDataType) fn) {
    return mapKeyDataType.dataTypeGeneric(
      <KR>() {
        return mapValueDataType.dataTypeGeneric(
          <VR>() {
            final self = this as MapDataType<KR, VR>;
            return fn(self);
          },
        );
      },
    );
  }
}

@Has()
typedef RepeatedItemDataType<T> = ScalarDataType<T>;

@Compose()
abstract class RepeatedDataType<T>
    implements
        DataTypeBits<List<T>>,
        DataType<List<T>>,
        HasRepeatedItemDataType<T> {
  static RepeatedDataType<T> of<T>({
    required RepeatedItemDataType<T> repeatedItemDataType,
  }) {
    return ComposedRepeatedDataType.dataTypeBits(
      dataTypeBits: DataTypeBits.of(
        readFieldValue: _getList(),
        defaultValue: const [],
      ),
      repeatedItemDataType: repeatedItemDataType,
    );
  }
}
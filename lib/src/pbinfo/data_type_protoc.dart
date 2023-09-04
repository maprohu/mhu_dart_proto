part of 'data_type.dart';

@Compose()
@Has()
abstract class FieldCoordinates implements HasFieldIndex, HasTagNumberValue {}

@Has()
typedef ReadFieldValue<F> = F Function(
  GeneratedMessage message,
  int fieldIndex,
);

@Has()
typedef WriteFieldValue<F> = void Function(
  GeneratedMessage message,
  FieldCoordinates fieldCoordinates,
  F value,
);

@Has()
typedef ExistsFieldValue = bool Function(
  GeneratedMessage message,
  TagNumberValue tagNumberValue,
);

@Has()
typedef ClearFieldValue = void Function(
  GeneratedMessage message,
  TagNumberValue tagNumberValue,
);

@Has()
typedef EnsureFieldValue<F> = F Function(
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

EnsureFieldValue<F> _ensure<F>() {
  return (message, fieldIndex) => message.$_ensure(fieldIndex);
}

extension HasReadFieldValueX<F> on HasReadFieldValue<F> {
  F Function(M message) readFieldValueFor<M extends GeneratedMessage>(
    int fieldIndex,
  ) {
    return (message) => readFieldValue(message, fieldIndex);
  }
}

WriteFieldValue<int> _setSignedInt32() {
  return (message, concreteFieldCalc, value) {
    message.$_setSignedInt32(
      concreteFieldCalc.fieldIndex,
      value,
    );
  };
}

WriteFieldValue<int> _setUnsignedInt32() {
  return (message, concreteFieldCalc, value) {
    message.$_setUnsignedInt32(
      concreteFieldCalc.fieldIndex,
      value,
    );
  };
}

WriteFieldValue<Int64> _setInt64() {
  return (message, concreteFieldCalc, value) {
    message.$_setInt64(
      concreteFieldCalc.fieldIndex,
      value,
    );
  };
}

WriteFieldValue<double> _setDouble() {
  return (message, concreteFieldCalc, value) {
    message.$_setDouble(
      concreteFieldCalc.fieldIndex,
      value,
    );
  };
}

WriteFieldValue<double> _setFloat() {
  return (message, concreteFieldCalc, value) {
    message.$_setFloat(
      concreteFieldCalc.fieldIndex,
      value,
    );
  };
}

WriteFieldValue<bool> _setBool() {
  return (message, concreteFieldCalc, value) {
    message.$_setBool(
      concreteFieldCalc.fieldIndex,
      value,
    );
  };
}

WriteFieldValue<String> _setString() {
  return (message, concreteFieldCalc, value) {
    message.$_setString(
      concreteFieldCalc.fieldIndex,
      value,
    );
  };
}

WriteFieldValue<List<int>> _setBytes() {
  return (message, concreteFieldCalc, value) {
    message.$_setBytes(
      concreteFieldCalc.fieldIndex,
      value,
    );
  };
}

WriteFieldValue<F> _setField<F extends Object>() {
  return (message, concreteFieldCalc, value) {
    message.setField(
      concreteFieldCalc.tagNumberValue,
      value,
    );
  };
}

bool _existsFieldValue(
  GeneratedMessage message,
  TagNumberValue tagNumber,
) {
  return message.hasField(tagNumber);
}

void _clearFieldValue(
  GeneratedMessage message,
  TagNumberValue tagNumber,
) {
  message.clearField(tagNumber);
}

extension ScalarDatatTypeProtocX on ScalarDataType {
  ExistsFieldValue get existsFieldValue => _existsFieldValue;

  ClearFieldValue get clearFieldValue => _clearFieldValue;

  bool Function(M message) existsFieldValueFor<M extends GeneratedMessage>(
    TagNumberValue tagNumber,
  ) {
    return (message) {
      return existsFieldValue(message, tagNumber);
    };
  }

  void Function(M message) clearFieldValueFor<M extends GeneratedMessage>(
    TagNumberValue tagNumber,
  ) {
    return (message) {
      return clearFieldValue(message, tagNumber);
    };
  }
}

extension HasWriteFieldValueX<T> on HasWriteFieldValue<T> {
  void Function(M message, T value)
      writeFieldValueFor<M extends GeneratedMessage>(
    FieldCoordinates fieldCoordinates,
  ) {
    return (message, value) {
      writeFieldValue(message, fieldCoordinates, value);
    };
  }
}


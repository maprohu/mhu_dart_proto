part of 'registry.dart';

extension RegistryConcreateFieldKeyX on ConcreteFieldKey {
  ({
    PbiMessage message,
    FieldInfo field,
  }) resolve() {
    final message = lookupPbiMessage(messageType);
    final field = message.builderInfo.fieldInfo[tagNumber]!;
    return (
      message: message,
      field: field,
    );
  }
}

extension ConcreteFieldKeyX on ConcreteFieldKey {
  @Deprecated('use concreteFieldCalc instead')

  /// use [concreteFieldCalc] instead
  PbiConcreteFieldCalc get calc => _registry._fieldCalc.get(this);

  ConcreteFieldCalc get concreteFieldCalc =>
      _registry._concreteFieldCalc.get(this);
}

class PbiConcreteFieldCalc<M extends GeneratedMessage, F> {
  final ConcreteFieldKey fieldKey;
  final PbiMessage<M> pbiMessage;
  final DataType<F> dataType;
  final FieldInfo<F> fieldInfo;

  PbiConcreteFieldCalc._({
    required this.fieldKey,
    required this.pbiMessage,
    required this.dataType,
    required this.fieldInfo,
  });

  static PbiConcreteFieldCalc create(ConcreteFieldKey fieldKey) {
    final messageType = fieldKey.messageType;
    final pbiMessage = lookupPbiMessage(messageType);
    final fieldInfo = pbiMessage.builderInfo.fieldInfo[fieldKey.tagNumber]!;
    final dataType = DataType.of(fieldInfo: fieldInfo);

    return pbiMessage.withGeneric(<M extends GeneratedMessage>(pbiMessage) {
      return dataType.dataTypeGeneric(<F>() {
        return PbiConcreteFieldCalc<M, F>._(
          fieldKey: fieldKey,
          pbiMessage: pbiMessage,
          dataType: dataType as DataType<F>,
          fieldInfo: fieldInfo as FieldInfo<F>,
        );
      });
    });
  }

  Type get messageType => fieldKey.messageType;

  String get name => fieldInfo.name;

  String get protoName => fieldInfo.protoName;

  int get tagNumber => fieldInfo.tagNumber;

  late final FieldAccess access = fieldInfo.access<M>();

  late final defaultSingleValue = access.defaultSingleValue;

  late final singleValueFieldAccess = access.let((access) {
    return switch (access) {
      ScalarFieldAccess() => access,
      MapFieldAccess(:final fieldInfo) =>
        fieldInfo.mapEntryBuilderInfo.byIndex[1].access(
          unsafe: true,
        ),
      RepeatedFieldAccess(:final fieldInfo) => fieldInfo.access(
          unsafe: true,
          type: fieldInfo.singleValueType,
        ),
    };
  });
}

part of 'registry.dart';

extension RegistryOneOfFieldKeyX on OneofFieldKey {
  PbiOneofCalc get calc => _registry._oneofCalc.get(this);
}

class PbiOneofCalc {
  final OneofFieldKey fieldKey;

  PbiOneofCalc(this.fieldKey);

  Type get messageType => fieldKey.messageType;

  int get oneofIndex => fieldKey.oneofIndex;

  late final message = lookupPbiMessage(messageType);

  late final oneof = message.oneofs[oneofIndex];

  late final fieldsInDescriptorOrder = message.tags
      .where(
        (tagNumber) => message.builderInfo.oneofs[tagNumber] == oneofIndex,
      )
      .map(
        (tagNumber) => ConcreteFieldKey(
          messageType: messageType,
          tagNumber: tagNumber,
        ).calc.access as ScalarFieldAccess,
      )
      .toIList();

  late final access = oneof.withGeneric(
    <M extends GeneratedMessage, E extends Enum>(pbiOneof) {
      // ignore: unnecessary_cast
      return OneofFieldAccess<M, E>(
        oneofIndex: oneofIndex,
        builderInfo: message.builderInfo,
        options: pbiOneof.which,
      ) as OneofFieldAccess;
    },
  );

  late final whichTagLookup = oneof.withGeneric(
    <M extends GeneratedMessage, E extends Enum>(pbiOneof) {
      // ignore: unnecessary_cast
      return createOneofLookup<E>(
        builderInfo: message.builderInfo,
        oneofIndex: oneofIndex,
        options: pbiOneof.which,
      ) as PbiOneofLookup;
    },
  );

  late final fieldByTagNumber = {
    for (final field in fieldsInDescriptorOrder) field.tagNumber: field,
  }.toIMap();

  late final fieldByWhich = {
    for (final field in fieldsInDescriptorOrder)
      whichTagLookup.tagToWhich[field.tagNumber]!: field,
  }.toIMap();
}

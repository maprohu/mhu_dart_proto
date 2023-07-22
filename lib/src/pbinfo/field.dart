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
  PbiConcreteFieldCalc get calc => _registry._fieldCalc.get(this);
}

class PbiConcreteFieldCalc {
  final ConcreteFieldKey fieldKey;

  PbiConcreteFieldCalc(this.fieldKey);

  Type get messageType => fieldKey.messageType;

  late final message = lookupPbiMessage(messageType);

  late final fieldInfo = message.builderInfo.fieldInfo[fieldKey.tagNumber]!;

  String get name => fieldInfo.name;

  int get tagNumber => fieldInfo.tagNumber;

  late final access = fieldInfo.accessForMessage(message);

  late final defaultSingleValue = access.defaultSingleValue;
}
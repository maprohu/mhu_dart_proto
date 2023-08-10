import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

import 'data_type.dart';

part 'field_calc.g.has.dart';

part 'field_calc.g.compose.dart';

typedef FieldDataType<T> = DataType<T>;

@Has()
typedef MessageType<M extends GeneratedMessage> = Type;

mixin FieldCalcMixin implements HasFieldKey {
  late final messageType = fieldKey.messageType;
  late final pbiMessage = lookupPbiMessage(messageType);
}

@Compose()
abstract base class FieldCalc with FieldCalcMixin implements HasFieldKey {
  static FieldCalc of(FieldKey fieldKey) =>
      ComposedFieldCalc(fieldKey: fieldKey);
}

mixin ConcreteFieldCalcMixin on FieldCalcMixin
    implements HasConcreteFieldKey, FieldCoordinates {
  @override
  late final tagNumberValue = concreteFieldKey.tagNumber;

  late final fieldInfo = pbiMessage.builderInfo.fieldInfo[tagNumberValue]!;

  late final DataType dataType = DataType.of(fieldInfo: fieldInfo);

  late final protoName = fieldInfo.protoName;

  @override
  late final fieldIndex = fieldInfo.index!;
}

@Compose()
abstract base class ConcreteFieldCalc
    with FieldCalcMixin, ConcreteFieldCalcMixin
    implements FieldCalc, HasConcreteFieldKey {
  static ConcreteFieldCalc of(ConcreteFieldKey fieldKey) =>
      ComposedConcreteFieldCalc(
        fieldKey: fieldKey,
        concreteFieldKey: fieldKey,
      );
}

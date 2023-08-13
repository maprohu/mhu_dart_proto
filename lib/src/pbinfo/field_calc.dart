import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

import 'data_type.dart';

part 'field_calc.g.has.dart';

part 'field_calc.g.compose.dart';

typedef FieldDataType<T> = DataType<T>;

@Has()
typedef MessageType<M extends GeneratedMessage> = Type;

@Compose()
abstract base class FieldCalc<M extends GeneratedMessage, F>
    implements HasFieldKey, HasPbiMessage<M> {}

base mixin ConcreteFieldCalcMixin<M extends GeneratedMessage, F>
    implements
        FieldCalc<M, F>,
        HasFieldInfo,
        HasConcreteFieldKey,
        FieldCoordinates {
  @override
  late final tagNumberValue = concreteFieldKey.tagNumber;

  late final protoName = fieldInfo.protoName;

  @override
  late final fieldIndex = fieldInfo.index!;

  late final pbiMessageCalc = pbiMessage.calc;

  R concreteFieldCalcGeneric<R>(
    R Function<MM extends GeneratedMessage, FF>(
      ConcreteFieldCalc<MM, FF> concreteFieldCalc,
    ) fn,
  ) {
    return fn(
      this as ConcreteFieldCalc<M, F>,
    );
  }
}

@Compose()
abstract base class ConcreteFieldCalc<M extends GeneratedMessage, F>
    with ConcreteFieldCalcMixin<M, F>
    implements
        FieldCalc<M, F>,
        HasConcreteFieldKey,
        HasDataType<F>,
        HasFieldInfo {
  static ConcreteFieldCalc create(ConcreteFieldKey fieldKey) {
    final messageType = fieldKey.messageType;
    final pbiMessage = lookupPbiMessage(messageType);
    final fieldInfo = pbiMessage.builderInfo.fieldInfo[fieldKey.tagNumber]!;
    final dataType = DataType.of(fieldInfo: fieldInfo);

    return pbiMessage.withGeneric(<M extends GeneratedMessage>(pbiMessage) {
      return dataType.dataTypeGeneric(<F>() {
        return ComposedConcreteFieldCalc<M, F>(
          concreteFieldKey: fieldKey,
          fieldKey: fieldKey,
          pbiMessage: pbiMessage,
          dataType: dataType as DataType<F>,
          fieldInfo: fieldInfo,
        );
      });
    });
  }
}

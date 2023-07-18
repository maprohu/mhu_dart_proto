import 'package:mhu_dart_commons/commons.dart';

import '../proto/descriptor.pb.dart';
import '../proto_descriptor.dart';
import '../proto_descriptor_hierarchy.dart';
import 'descriptor_message.dart';
import 'descriptor_oneof.dart';

class PdFld<M, F, E> implements HasPayload<F> {
  final PdMsg<M, F, E> msg;
  final int index;

  PdFld({
    required this.msg,
    required this.index,
  });

  late final int globalIndex =
      msg.root.nonMapEntryFieldsFlattened.indexOf(this);

  @override
  late final payload = msg.root.fldPayload(this);

  late final descriptor = msg.descriptor.field[index];

  late final name = descriptor.name;

  late final isLabelRepeated =
      descriptor.label == FieldDescriptorProto_Label.LABEL_REPEATED;
  late final isTypeMessage =
      descriptor.type == FieldDescriptorProto_Type.TYPE_MESSAGE;
  late final isTypeEnum =
      descriptor.type == FieldDescriptorProto_Type.TYPE_ENUM;

  late final descTypeName = descriptor.typeName;
  late final descTypeNameList = descTypeName.split('.');

  late final resolvedMessage = msg.resolve(descTypeNameList);
  late final resolvedEnum = msg.resolveEnum(descTypeNameList);

  late final isMap =
      isLabelRepeated && isTypeMessage && resolvedMessage.isMapEntry;
  late final isSingle = !isLabelRepeated;

  late final isRepeated = isLabelRepeated && !isMap;

  late final isCollection = isMap || isRepeated;

  late final mapKeyField = resolvedMessage.fields[0];
  late final mapValueField = resolvedMessage.fields[1];

  late final mapFields = MapFields(mapKeyField, mapValueField);

  late final cardinality = PdfCardinality.from(this);

  late final singleValueType = PdfValueType.from(this);

  late final singleValueField = switch (cardinality) {
    PdfMapOf(:final fields) => fields.value,
    _ => this,
  };

  late final oneofIndex =
      descriptor.hasOneofIndex() ? descriptor.oneofIndex : null;

  late final isOneof = oneofIndex != null;

  late final PdOneof<M, F, E> oneof = msg.oneofs[oneofIndex!];

  late final PdxBase<M, F, E> exclusivity =
      isOneof ? oneof.exclusivity : PdxTop<M, F, E>(this);
}

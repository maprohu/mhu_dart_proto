import 'descriptor/descriptor_enum.dart';
import 'descriptor/descriptor_field.dart';
import 'descriptor/descriptor_message.dart';
import 'proto/descriptor.pb.dart';

class MapFields<M, F, E> {
  final PdFld<M, F, E> key;
  final PdFld<M, F, E> value;

  MapFields(this.key, this.value);
}

sealed class PdfCardinality<M, F, E> {
  const PdfCardinality();

  static PdfCardinality<M, F, E> from<M, F, E>(PdFld<M, F, E> fld) {
    if (fld.isMap) {
      return PdfMapOf(fld.mapFields);
    } else if (fld.isRepeated) {
      return PdfRepeated();
    } else {
      return PdfSingle();
    }
  }
}

class PdfMapOf<M, F, E> extends PdfCardinality<M, F, E> {
  final MapFields<M, F, E> fields;

  const PdfMapOf(this.fields);
}

sealed class PdfNonMap<M, F, E> extends PdfCardinality<M, F, E> {
  const PdfNonMap();
}

class PdfSingle<M, F, E> extends PdfNonMap<M, F, E> {
  const PdfSingle();
}

class PdfRepeated<M, F, E> extends PdfNonMap<M, F, E> {
  const PdfRepeated();
}

sealed class PdfValueType<M, F, E> {
  const PdfValueType();

  static PdfValueType<M, F, E> _fromValue<M, F, E>(PdFld<M, F, E> fld) =>
      BaseType.typeOf(fld);

  static PdfValueType<M, F, E> from<M, F, E>(PdFld<M, F, E> fld) {
    return switch (fld.cardinality) {
      PdfMapOf(:final fields) => _fromValue(fields.value),
      PdfNonMap() => _fromValue(fld),
    };
  }
}

class PdfBoolType<M, F, E> extends PdfValueType<M, F, E> {
  const PdfBoolType();
}

class PdfDoubleType<M, F, E> extends PdfValueType<M, F, E> {
  const PdfDoubleType();
}

class PdfIntType<M, F, E> extends PdfValueType<M, F, E> {
  const PdfIntType();
}

class PdfInt64Type<M, F, E> extends PdfValueType<M, F, E> {}

class PdfStringType<M, F, E> extends PdfValueType<M, F, E> {}

class PdfBytesType<M, F, E> extends PdfValueType<M, F, E> {}

class PdfEnumType<M, F, E> extends PdfValueType<M, F, E> {
  final PdEnum<M, F, E> pdEnum;

  const PdfEnumType(this.pdEnum);
}

class PdfMessageType<M, F, E> extends PdfValueType<M, F, E> {
  final PdMsg<M, F, E> pdMsg;

  const PdfMessageType(this.pdMsg);
}

class BaseType {
  static PdfValueType<M, F, E> typeOf<M, F, E>(PdFld<M, F, E> fld) {
    final field = fld.descriptor;

    switch (field.type) {
      case FieldDescriptorProto_Type.TYPE_BOOL:
        return PdfBoolType();
      case FieldDescriptorProto_Type.TYPE_FLOAT:
      case FieldDescriptorProto_Type.TYPE_DOUBLE:
        return PdfDoubleType();
      case FieldDescriptorProto_Type.TYPE_INT32:
      case FieldDescriptorProto_Type.TYPE_UINT32:
      case FieldDescriptorProto_Type.TYPE_SINT32:
      case FieldDescriptorProto_Type.TYPE_FIXED32:
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        return PdfIntType();
      case FieldDescriptorProto_Type.TYPE_INT64:
      case FieldDescriptorProto_Type.TYPE_UINT64:
      case FieldDescriptorProto_Type.TYPE_SINT64:
      case FieldDescriptorProto_Type.TYPE_FIXED64:
      case FieldDescriptorProto_Type.TYPE_SFIXED64:
        return PdfInt64Type();
      case FieldDescriptorProto_Type.TYPE_STRING:
        return PdfStringType();
      case FieldDescriptorProto_Type.TYPE_BYTES:
        return PdfBytesType();

      case FieldDescriptorProto_Type.TYPE_MESSAGE:
        return PdfMessageType(fld.resolvedMessage);
      case FieldDescriptorProto_Type.TYPE_ENUM:
        return PdfEnumType(fld.resolvedEnum);
      default:
        throw ArgumentError('unimplemented type: ${field.type.name}');
    }
  }
}

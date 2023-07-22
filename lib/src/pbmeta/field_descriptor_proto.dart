import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_dart_proto/src/pbmeta/descriptor_proto.dart';

class PbmFieldDescriptorProto {
  final IndexedParentReference<PbmDescriptorProto> parent;
  final FieldDescriptorProto fieldDescriptorProto;

  const PbmFieldDescriptorProto({
    required this.parent,
    required this.fieldDescriptorProto,
  });
}
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_dart_proto/src/pbmeta/file_descriptor_proto.dart';

class PbmDescriptorProto {
  final PbmDescriptorProtoParent parent;
  final DescriptorProto descriptorProto;

  PbmDescriptorProto({
    required this.parent,
    required this.descriptorProto,
  });
}

sealed class PbmDescriptorProtoParent {}

class PbmDescriptorProtoFileParent extends PbmDescriptorProtoParent {
  final IndexedParentReference<PbmFileDescriptorProto> reference;

  PbmDescriptorProtoFileParent(this.reference);
}

class PbmDescriptorProtoMessageParent extends PbmDescriptorProtoParent {
  final IndexedParentReference<PbmDescriptorProto> reference;

  PbmDescriptorProtoMessageParent(this.reference);
}

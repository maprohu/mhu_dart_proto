import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';

class PbmFileDescriptorProto {
  final IndexedParentReference<PbmLibrary> parentReference;
  final FileDescriptorProto fileDescriptorProto;

  PbmFileDescriptorProto({
    required this.parentReference,
    required this.fileDescriptorProto,
  });
}

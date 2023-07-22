import 'package:collection/collection.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_dart_proto/src/pbmeta/file_descriptor_proto.dart';

class PbmLibrary {
  final String name;
  final FileDescriptorSet fileDescriptorSet;
  final Iterable<PbmLibrary> importedLibraries;

  const PbmLibrary({
    required this.name,
    required this.fileDescriptorSet,
    required this.importedLibraries,
  });

  Iterable<PbmFileDescriptorProto> get pbmFileDescriptorProtos =>
      fileDescriptorSet.file.mapIndexed(
        (index, element) => PbmFileDescriptorProto(
          parentReference: IndexedParentReference(
            parent: this,
            index: index,
          ),
          fileDescriptorProto: element,
        ),
      );
}

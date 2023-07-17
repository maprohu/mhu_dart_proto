import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:protobuf/protobuf.dart';

import 'proto_meta.dart';

part 'proto_path.freezed.dart';

@freezed
sealed class ProtoPath with _$ProtoPath {
  const factory ProtoPath.root() = ProtoPathRoot;

  const factory ProtoPath.field({
    required ProtoPath parent,
    required PmMsgFieldOfMessageOfType field,
  }) = ProtoPathField;

  const factory ProtoPath.repeated({
    required ProtoPath parent,
    required PmRepeatedField field,
    required int index,
  }) = ProtoPathRepeated;

  const factory ProtoPath.mapOf({
    required ProtoPath parent,
    required PmMapField field,
    required Object key,
  }) = ProtoPathMapOf;
}

extension ProtoPathX on ProtoPath {
  ProtoPath andField(PmMsgFieldOfMessageOfType field) => ProtoPath.field(
    parent: this,
    field: field,
  );
}
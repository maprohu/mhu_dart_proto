import 'package:mhu_dart_commons/commons.dart';

import '../descriptor.pb.dart';
import 'descriptor_message_container.dart';

abstract class PdEnumResolver<M, F, E> {
  PdEnum<M, F, E> resolveEnum(Iterable<String> path);
}

class PdEnum<M, F, E> implements PdEnumResolver<M, F, E>, HasPayload<E> {
  final PdMsgContainer<M, F, E> parent;
  final EnumDescriptorProto descriptor;
  final int index;

  PdEnum(this.parent, this.descriptor, this.index);

  late final root = parent.root;

  late final payload = root.enumPayload(this);

  late final name = descriptor.name;

  PdEnum<M, F, E> resolveEnum(Iterable<String> path) {
    assert(path.isEmpty);
    return this;
  }
}

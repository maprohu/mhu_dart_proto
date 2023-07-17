
import '../proto_descriptor.dart';
import 'descriptor_message.dart';

class PdOneof<M, F, E> {
  final PdMsg<M, F, E> msg;
  final int index;

  PdOneof(this.msg, this.index);

  late final descriptor = msg.descriptor.oneofDecl[index];
  late final name = descriptor.name;

  late final PdxBase<M, F, E> exclusivity = PdxOneof(this);

  late final fields = msg.fields.where((e) => e.oneofIndex == index).toList();
}

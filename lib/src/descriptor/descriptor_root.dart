import 'package:mhu_dart_commons/commons.dart';

import '../proto/descriptor.pb.dart';
import 'descriptor_enum.dart';
import 'descriptor_field.dart';
import 'descriptor_message.dart';
import 'descriptor_message_container.dart';

class PdRoot<M, F, E> extends PdMsgContainer<M, F, E> {
  final M Function(PdMsg<M, F, E> msg) _msg;
  final F Function(PdFld<M, F, E> fld) _fld;
  final E Function(PdEnum<M, F, E> enm) _enm;
  final FileDescriptorProto descriptorProto;
  final Iterable<FileDescriptorProto> importedDescriptorProtos;

  // @override
  // int get globalIndex => 0;
  //
  // @override
  // int get globalFieldIndex => 0;

  @override
  int get localFieldsCount => 0;

  M msgPayload(PdMsg<M, F, E> msg) => _msg(msg);

  F fldPayload(PdFld<M, F, E> fld) => _fld(fld);

  E enumPayload(PdEnum<M, F, E> enm) => _enm(enm);

  @override
  PdRoot<M, F, E> get root => this;

  @override
  Iterable<DescriptorProto> get messageDescriptors =>
      descriptorProto.messageType;

  @override
  PdMsg<M, F, E> resolve(Iterable<String> path) => doResolveNext(path);

  @override
  final path = Iterable.empty();

  @override
  Iterable<EnumDescriptorProto> get enumDescriptors => descriptorProto.enumType;

  @override
  PdMsg<M, F, E> toMessage() => throw this;

  @override
  PdMsg<M, F, E> doResolveMessageIndex(Iterable<int> path) =>
      doResolveMessageIndexNext(path);

  @override
  PdEnum<M, F, E> doResolveEnumIndex(Iterable<int> path) => path.tail.isEmpty
      ? enums[path.first]
      : messages[path.first].resolveEnumIndex(path.tail);

  late final List<PdFld<M, F, E>> allFields = [
    ...messages.expand((e) => e.allFields),
  ];

  late final List<PdMsg<M, F, E>> nonMapEntryMessagesFlattened =
      messages.expand((e) => e.nonMapEntryMessagesFlattened).toList();

  late final List<PdFld<M, F, E>> nonMapEntryFieldsFlattened =
      messages.expand((e) => e.nonMapEntryFieldsFlattened).toList();

  PdRoot({
    required this.descriptorProto,
    this.importedDescriptorProtos = const Iterable.empty(),
    required M Function(PdMsg<M, F, E> msg) msg,
    required F Function(PdFld<M, F, E> fld) fld,
    required E Function(PdEnum<M, F, E> enm) enm,
  })  : _msg = msg,
        _fld = fld,
        _enm = enm;

  @override
  Iterable<EnumDescriptorProto> get importedEnumDescriptors =>
      importedDescriptorProtos.expand((element) => element.enumType);

  @override
  Iterable<DescriptorProto> get importedMessageDescriptors =>
      importedDescriptorProtos.expand((element) => element.messageType);
}

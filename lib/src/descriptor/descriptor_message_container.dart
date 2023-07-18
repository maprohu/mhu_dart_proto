import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_commons/commons.dart';

import '../proto/descriptor.pb.dart';
import 'descriptor_enum.dart';
import 'descriptor_message.dart';
import 'descriptor_root.dart';

abstract class PdMsgContainer<M, F, E> implements PdEnumResolver<M, F, E> {
  int get localFieldsCount;

  PdRoot<M, F, E> get root;

  Iterable<DescriptorProto> get messageDescriptors;

  Iterable<EnumDescriptorProto> get enumDescriptors;

  Iterable<DescriptorProto> get importedMessageDescriptors;

  Iterable<EnumDescriptorProto> get importedEnumDescriptors;

  PdMsg<M, F, E> pdMsgFromDescriptor(
    int index,
    DescriptorProto descriptor,
  ) {
    return PdMsg(
      parent: this,
      descriptor: descriptor,
      index: index,
    );
  }

  PdEnum<M, F, E> pdEnumFromDescriptor(
    int index,
    EnumDescriptorProto descriptor,
  ) {
    return PdEnum(
      this,
      descriptor,
      index,
    );
  }

  late final List<PdMsg<M, F, E>> messages =
      messageDescriptors.mapIndexed(pdMsgFromDescriptor).toList();

  late final List<PdMsg<M, F, E>> importedMessages =
      importedMessageDescriptors.mapIndexed(pdMsgFromDescriptor).toList();

  late final List<PdEnum<M, F, E>> enums =
      enumDescriptors.mapIndexed(pdEnumFromDescriptor).toList();

  late final List<PdEnum<M, F, E>> importedEnums =
      importedEnumDescriptors.mapIndexed(pdEnumFromDescriptor).toList();

  late final resolveDirectCache = <String, PdMsgContainer<M, F, E>>{
    '': root,
    for (final m in messages) m.name: m,
    for (final m in importedMessages) m.name: m,
  }.toIMap();

  late final resolveEnumDirectCache = <String, PdEnumResolver<M, F, E>>{
    '': root,
    for (final m in messages) m.name: m,
    for (final m in importedMessages) m.name: m,
    for (final e in enums) e.name: e,
    for (final e in importedEnums) e.name: e,
  }.toIMap();

  PdMsg<M, F, E> resolve(Iterable<String> path);

  PdMsg<M, F, E> doResolveNext(Iterable<String> path) =>
      resolveDirectCache[path.first]!.resolve(path.tail);

  @override
  PdEnum<M, F, E> resolveEnum(Iterable<String> path) =>
      resolveEnumDirectCache[path.first]?.resolveEnum(path.tail) ??
      (throw path);

  Iterable<PdMsg<M, F, E>> get path;

  late final isRoot = path.isEmpty;

  PdMsg<M, F, E> toMessage();

  PdMsg<M, F, E> doResolveMessageIndex(Iterable<int> path);

  late final resolveMessageIndex = Cache(doResolveMessageIndex);

  PdEnum<M, F, E> doResolveEnumIndex(Iterable<int> path);

  late final resolveEnumIndex = Cache(doResolveEnumIndex);

  PdMsg<M, F, E> doResolveMessageIndexNext(Iterable<int> path) =>
      messages[path.first].doResolveMessageIndex(path.tail);

  late final asRoot = this as PdRoot<M, F, E>;
  late final asMsg = this as PdMsg<M, F, E>;

  R when<R>({
    required R Function(PdRoot<M, F, E> root) root,
    required R Function(PdMsg<M, F, E> msg) msg,
  }) =>
      isRoot ? root(asRoot) : msg(asMsg);

  late final List<PdMsg<M, F, E>> allMessages =
      messages.expand((e) => e.allMessages).toList(growable: false);
}

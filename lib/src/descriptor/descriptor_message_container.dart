import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_commons/commons.dart';

import '../descriptor.pb.dart';
import 'descriptor_enum.dart';
import 'descriptor_message.dart';
import 'descriptor_root.dart';

abstract class PdMsgContainer<M, F, E> implements PdEnumResolver<M, F, E> {
  int get localFieldsCount;

  PdRoot<M, F, E> get root;

  Iterable<DescriptorProto> get messageDescriptors;

  Iterable<EnumDescriptorProto> get enumDescriptors;

  late final messages = messageDescriptors
      .mapIndexed(
        (i, e) => PdMsg(
          parent: this,
          descriptor: e,
          index: i,
        ),
      )
      .toList();

  late final enums =
      enumDescriptors.mapIndexed((i, e) => PdEnum(this, e, i)).toList();

  late final resolveDirectCache = <String, PdMsgContainer<M, F, E>>{
    '': root,
    for (final m in messages) m.name: m,
  }.toIMap();

  late final resolveEnumDirectCache = <String, PdEnumResolver<M, F, E>>{
    '': root,
    for (final m in messages) m.name: m,
    for (final e in enums) e.name: e,
  }.toIMap();

  PdMsg<M, F, E> resolve(Iterable<String> path);

  PdMsg<M, F, E> doResolveNext(Iterable<String> path) =>
      resolveDirectCache[path.first]!.resolve(path.tail);

  PdEnum<M, F, E> resolveEnum(Iterable<String> path) =>
      resolveEnumDirectCache[path.first]!.resolveEnum(path.tail);

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

part of 'registry.dart';

class PbiOneof<M extends GeneratedMessage, E extends Enum> {
  final String name;
  final List<E> which;

  const PbiOneof({
    required this.name,
    required this.which,
  });

  R withGeneric<R>(
    R Function<MT extends GeneratedMessage, ET extends Enum>(
      PbiOneof<MT, ET> pbiOneof,
    ) fn,
  ) =>
      fn(this);
}
// typedef PbiOneof<E extends Enum> = ({
//   String name,
//   List<E> which,
// });

class PbiMessage<M extends GeneratedMessage> {
  final M instance;
  final List<PbiOneof<M, Enum>> oneofs;
  final List<int> tags;

  PbiMessage({
    required this.instance,
    required this.oneofs,
    required this.tags,
  }) {
    assert(M != GeneratedMessage);
  }

  BuilderInfo get builderInfo => instance.info_;

  Type get messageType => M;

  R withGeneric<R>(
    R Function<T extends GeneratedMessage>(PbiMessage<T> pbiMessage) fn,
  ) {
    return fn(this);
  }
}

extension MessageGetDefaultX<M extends GeneratedMessage> on M {
  PbiMessage<M> toPbiMessage({
    required List<int> tags,
    required List<PbiOneof<M, Enum>> oneofs,
  }) =>
      PbiMessage(
        instance: this,
        oneofs: oneofs,
        tags: tags,
      );
}

extension PbiGeneratedMessageX<M extends GeneratedMessage> on M {
  PbiMessage<M> get pbi => _registry._msgByType[runtimeType]!.cast();
}

PbiMessage lookupPbiMessage(Type messageType) =>
    _registry._msgByType[messageType] ?? (throw messageType);

extension PbiMessageX on PbiMessage {
  PbiMessageCalc get calc => _registry._msgCalc(this);
}

class PbiMessageCalc {
  final PbiMessage msg;

  PbiMessageCalc(this.msg);

  BuilderInfo get builderInfo => msg.builderInfo;

  Type get messageType => msg.messageType;

  late final topFieldKeys = msg.tags
      .map((tagNumber) {
        final oneofIndex = builderInfo.oneofs[tagNumber];

        if (oneofIndex != null) {
          return OneofFieldKey(
            messageType: messageType,
            oneofIndex: oneofIndex,
          );
        } else {
          return ConcreteFieldKey(
            messageType: messageType,
            tagNumber: tagNumber,
          );
        }
      })
      .distinct()
      .toIList();

  late final concreteFieldKeysInDescriptorOrder = msg.tags
      .map(
        (tagNumber) => ConcreteFieldKey(
          messageType: messageType,
          tagNumber: tagNumber,
        ),
      )
      .toIList();

  late final concreteFieldCalcsInDescriptorOrder =
      concreteFieldKeysInDescriptorOrder.map((f) => f.calc).toIList();

  late final oneofFieldKeys = msg.oneofs
      .mapIndexed(
        (oneofIndex, element) => OneofFieldKey(
          messageType: messageType,
          oneofIndex: oneofIndex,
        ),
      )
      .toIList();

  late final oneofFieldCalcs = oneofFieldKeys.map((e) => e.calc).toIList();
}

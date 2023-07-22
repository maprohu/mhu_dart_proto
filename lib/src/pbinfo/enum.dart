part of 'registry.dart';

class PbiEnum<E extends ProtobufEnum> {
  final List<E> values;

  const PbiEnum({
    required this.values,
  });

  Type get enumType => E;

  R withEnumType<R>(R Function<T extends ProtobufEnum>() fn) => fn<E>();
}

extension ProtobufEnumValuesX<E extends ProtobufEnum> on List<E> {
  PbiEnum<E> get toPbiEnum => PbiEnum(values: this);
}

extension PbiProtobufEnumX<E extends ProtobufEnum> on E {
  PbiEnum<E> get pbi => _PbiRegistry.instance._enumByType[runtimeType]!.cast();
}

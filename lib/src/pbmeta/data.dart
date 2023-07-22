import 'package:freezed_annotation/freezed_annotation.dart';

part 'data.freezed.dart';

@freezed
class FdsLibRef with _$FdsLibRef {
  const factory FdsLibRef({
    required String name,
  }) = _FdsLibRef;
}

@freezed
class FdsFileRef with _$FdsFileRef {
  const factory FdsFileRef({
    required FdsLibRef lib,
    required int index,
  }) = _FdsFileRef;
}

@freezed
class FdsEnumRef with _$FdsEnumRef {
  const factory FdsEnumRef({
    required FdsFileRef file,
    required int index,
  }) = _FdsEnumRef;
}

@freezed
sealed class FdsMessageRef with _$FdsMessageRef {
  const factory FdsMessageRef.top({
    required FdsFileRef file,
    required int index,
  }) = FdsTopMessageRef;

  const factory FdsMessageRef.nested({
    required FdsMessageRef message,
    required int index,
  }) = FdsNestedMessageRef;
}

import 'descriptor/descriptor_enum.dart';
import 'descriptor/descriptor_field.dart';
import 'descriptor/descriptor_message.dart';
import 'descriptor/descriptor_oneof.dart';

sealed class PdxBase<M, F, E> {
  const PdxBase();
}

class PdxTop<M, F, E> extends PdxBase<M, F, E> {
  final PdFld<M, F, E> top;

  const PdxTop(this.top);
}

class PdxOneof<M, F, E> extends PdxBase<M, F, E> {
  final PdOneof<M, F, E> oneof;

  const PdxOneof(this.oneof);
}


abstract class HasPdMsg<M, F, E> {
  PdMsg<M, F, E> get msg;
}

abstract class HasPdFld<M, F, E> {
  PdFld<M, F, E> get fld;
}

abstract class HasPdEnum<M, F, E> {
  PdEnum<M, F, E> get enm;
}

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/src/pbinfo/data_type.dart';
import 'package:protobuf/protobuf.dart';

import 'field_calc.dart';
import 'pbinfo.dart';

part 'message.dart';

part 'field.dart';

part 'enum.dart';

part 'oneof.dart';

part 'registry.g.has.dart';
// part 'registry.g.compose.dart';


class _PbiRegistry {
  _PbiRegistry._();

  static final instance = _PbiRegistry._();

  final _libs = <PbiLib>{};

  final _msgByType = <Type, PbiMessage>{};
  final _enumByType = <Type, PbiEnum>{};

  void register(PbiLib lib) {
    if (_libs.add(lib)) {
      for (final msg in lib.messages) {
        _msgByType[msg.messageType] = msg;
      }
      for (final enm in lib.enums) {
        _enumByType[enm.enumType] = enm;
      }
    }
  }

  final _msgCalc = Cache<PbiMessage, PbiMessageCalc>((msg) => msg._calc());
  final _fieldCalc = Cache(PbiConcreteFieldCalc.create);
  final _oneofCalc = Cache(PbiOneofCalc.new);

  // final _topFieldCalc = Cache(FieldCalc.of);
  final _concreteFieldCalc = Cache(ConcreteFieldCalc.create);
}

extension TopFieldKeyX on FieldKey {
  // FieldCalc get fieldCalc => _registry._topFieldCalc.get(this);
}

final _registry = _PbiRegistry.instance;

class PbiLib {
  final String name;
  final Iterable<PbiMessage> messages;
  final Iterable<PbiEnum> enums;
  final Iterable<PbiLib> importedLibraries;

  PbiLib({
    required this.name,
    required this.messages,
    required this.enums,
    required this.importedLibraries,
  }) {
    _PbiRegistry.instance.register(this);
  }

  void register() {
    // noop, done in constructor
  }

  Iterable<PbiLib> get allLibs => [this].followedBy(allImportedLibraries);

  Iterable<PbiLib> get allImportedLibraries =>
      importedLibraries.expand((element) => element.allLibs).distinct();
}

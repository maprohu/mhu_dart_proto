import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:protobuf/protobuf.dart';

part 'message.dart';
part 'field.dart';
part 'enum.dart';
part 'oneof.dart';

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

  final _msgCalc = Cache(PbiMessageCalc.new);
  final _fieldCalc = Cache(PbiConcreteFieldCalc.new);
  final _oneofCalc = Cache(PbiOneofCalc.new);
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


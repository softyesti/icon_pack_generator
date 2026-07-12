import 'package:icon_pack_generator/src/entities/icon_entity.dart';
import 'package:recase/recase.dart';

const _template = '''
  static const %ICON_NAME% = IconData(0x%ICON_CODE%, fontFamily: _fontFamily, fontPackage: _fontPackage);
''';

abstract class IconTemplate {
  const IconTemplate();

  static String generate(IconEntity icon) {
    return _template
        .replaceFirst('%ICON_NAME%', icon.name.camelCase)
        .replaceFirst('%ICON_CODE%', icon.code.toRadixString(16));
  }
}

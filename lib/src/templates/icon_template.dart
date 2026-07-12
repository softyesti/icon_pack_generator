import 'package:icon_pack_generator/src/entities/icon_entity.dart';
import 'package:recase/recase.dart';

const _template = '''
  /// <img alt="%ALT%" src="data:image/svg+xml;utf8,%DATA%" width="64" height="64" />
  static const %NAME% = IconData(0x%CODE%, fontFamily: _fontFamily, fontPackage: _fontPackage);
''';

/// Icon template class.
abstract class IconTemplate {
  /// Creates a new [IconTemplate];
  const IconTemplate();

  /// Fill out the template with the necessary information.
  static String generate(IconEntity icon) {
    return _template
        .replaceFirst('%ALT%', icon.name.snakeCase)
        .replaceFirst('%DATA%', icon.data)
        .replaceFirst('%NAME%', icon.name.camelCase)
        .replaceFirst('%CODE%', icon.code.toRadixString(16));
  }
}

import 'dart:io';

import 'package:icon_pack_generator/entities/icon_entity.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

const _template = '''
extension %CLASS_NAME%Extension on IconData {
  String getPath() => _%ICON_MAP%Map[codePoint]!;
}

const _%ICON_MAP%Map = {
%ICON_MAPS%
};
''';

abstract class IconPackExtTemplate {
  static String generate({
    required Directory source,
    required String className,
    required List<IconEntity> icons,
  }) {
    final entries = icons.map((icon) {
      final code = icon.code.toRadixString(16);
      final filename = p.setExtension(icon.name.snakeCase, '.svg');
      final path = p.relative(p.join(source.path, filename));

      return '  0x$code: $path,';
    });

    var template = _template.replaceAll('%CLASS_NAME%', className);
    template = template.replaceAll('%ICON_MAP%', className.camelCase);

    return template.replaceFirst('%ICON_MAPS%', entries.join('\n'));
  }
}

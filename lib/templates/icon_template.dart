import 'package:icon_pack_generator/entities/icon_entity.dart';
import 'package:recase/recase.dart';

const _template = '''
  static const IconData %ICON_NAME% = _%CLASS_NAME%Data(0x%ICON_CODE%);''';

abstract class IconTemplate {
  static String generate({
    required IconEntity icon,
    required String className,
  }) {
    final name = icon.name.camelCase;
    final code = icon.code.toRadixString(16);

    var template = _template.replaceAll('%CLASS_NAME%', className.pascalCase);
    template = template.replaceFirst('%ICON_NAME%', name);
    return template.replaceFirst('%ICON_CODE%', code);
  }
}

import 'package:recase/recase.dart';

const _template = '''
// icon_pack_generator by SoftYesTI<https://softyes.com.br>.
// Automatically generated code. Do not change it manually.

import 'package:flutter/widgets.dart';

@immutable
abstract class %CLASS_NAME% {
  const %CLASS_NAME%();

  static const _fontFamily = '%FONT_FAMILY%';
  static const _fontPackage = '%PACKAGE_NAME%';

%ICON_PACK%
}
''';

abstract class IconPackTemplate {
  const IconPackTemplate();

  static String generate({
    required String className,
    required String packageName,
    required String iconPack,
  }) {
    return _template
        .replaceAll('%CLASS_NAME%', className.pascalCase)
        .replaceFirst('%FONT_FAMILY%', className.snakeCase)
        .replaceFirst('%PACKAGE_NAME%', packageName)
        .replaceFirst('%ICON_PACK%', iconPack);
  }
}

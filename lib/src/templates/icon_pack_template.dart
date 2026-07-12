import 'package:recase/recase.dart';

const _template = '''
// Soft Icon Generator
// Automatically generated code. Do not change it manually

import 'package:flutter/widgets.dart';

%ICON_DATA_TEMPLATE%

@immutable
abstract class %CLASS_NAME% {
%ICON_PACK%
}

%ICON_PACK_EXT_TEMPLATE%

''';

abstract class IconPackTemplate {
  static String generate({
    required String className,
    required String iconData,
    required String iconPack,
    required String iconPackExt,
  }) {
    var template = _template.replaceAll('%CLASS_NAME%', className.pascalCase);
    template = template.replaceFirst('%ICON_DATA_TEMPLATE%', iconData);
    template = template.replaceFirst('%ICON_PACK%', iconPack);
    template = template.replaceFirst('%ICON_PACK_EXT_TEMPLATE%', iconPackExt);

    return template;
  }
}

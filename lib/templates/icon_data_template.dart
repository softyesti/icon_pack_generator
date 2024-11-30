import 'package:recase/recase.dart';

const _template = '''
@immutable
class _%CLASS_NAME%Data extends IconData {
  const _%CLASS_NAME%Data(super.codePoint)
      : super(
          fontFamily: '%CLASS_NAME%',
          fontPackage: '%PACKAGE_NAME%',
        );
}
''';

abstract class IconDataTemplate {
  static String generate({
    required String className,
    required String packageName,
  }) {
    final template = _template.replaceAll('%CLASS_NAME%', className.pascalCase);
    return template.replaceFirst('%PACKAGE_NAME%', packageName.snakeCase);
  }
}

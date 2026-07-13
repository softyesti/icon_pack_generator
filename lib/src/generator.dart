//
// ignore_for_file: inference_failure_on_untyped_parameter, avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:icon_pack_generator/src/entities/icon_entity.dart';
import 'package:icon_pack_generator/src/templates/icon_pack_template.dart';
import 'package:icon_pack_generator/src/templates/icon_template.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

/// A class that exposes the methods for creating an icon pack.
class IconPackGenerator {
  /// Creates a new [IconPackGenerator].
  const IconPackGenerator({
    required this.className,
    required this.packageName,
    required this.iconSource,
    required this.fontTarget,
    required this.classTarget,
  });

  /// The name of the main class.
  final String className;

  /// The package name.
  final String packageName;

  /// Directory containing the .svg icons.
  final Directory iconSource;

  /// Destination directory for the font file.
  final Directory fontTarget;

  /// Destination directory for the class file.
  final Directory classTarget;

  /// Rename the files to snake_case.
  Future<void> rename() async {
    final files = await iconSource.list().toList();
    final queue = <Future<FileSystemEntity>>[];

    for (final file in files) {
      final extension = p.extension(file.path);
      final name = ReCase(p.basenameWithoutExtension(file.path)).snakeCase;
      final newPath = p.join(iconSource.path, p.setExtension(name, extension));

      queue.add(file.rename(newPath));
    }

    await Future.wait(queue);
  }

  /// Extract the SVGs data, create the font file, and map the glyphs.
  Future<List<IconEntity>> genFont() async {
    final name = className.snakeCase;
    final output = fontTarget.path;

    final icons = <String, String>{};
    await iconSource.list().forEach((fs) async {
      final name = p.basenameWithoutExtension(fs.path);
      var content = await File(fs.path).readAsString();
      content = content
          .replaceAll('"', "'")
          .replaceAll('#', '%23')
          .replaceAll('> <', '><')
          .replaceAll(RegExp(r'\s+'), ' ')
          .replaceAll('black', 'currentColor')
          .trim();

      icons.addAll({name: content});
    });

    await Process.start(
      'npx',
      runInShell: true,
      [
        'fantasticon',
        '--name',
        name,
        '--font-types',
        'ttf',
        '--asset-types',
        'json',
        '--output',
        output,
        iconSource.path,
      ],
    );

    final dataFile = File(p.join(output, p.setExtension(name, '.json')));
    final dataString = await dataFile.readAsString();
    final dataMap = jsonDecode(dataString) as Map<String, dynamic>;

    final data = dataMap.entries.indexed.map((e) {
      return IconEntity(
        code: e.$2.value as int,
        name: e.$2.key,
        data: icons[e.$2.key]!,
      );
    }).toList();

    await dataFile.delete();
    return data;
  }

  /// Creates the main class of the icon pack.
  Future<String> genClass({required List<IconEntity> icons}) async {
    return IconPackTemplate.generate(
      className: className,
      packageName: packageName,
      iconPack: icons.map(IconTemplate.generate).join('\n'),
    );
  }

  /// Write the main class to the destination directory.
  Future<void> writeClass(String content) async {
    final name = className.snakeCase;
    final output = p.absolute(classTarget.path);
    final path = p.setExtension(p.join(output, name), '.dart');

    var file = File(path);
    file = await file.create();
    await file.writeAsString(content);
  }

  /// Update the pubspec with the mapping to the font files.
  Future<void> writePubspec() async {
    final family = className.pascalCase;
    final filename = p.setExtension(className.snakeCase, '.ttf');
    final path = p.relative(p.join(fontTarget.path, filename));

    final file = File(p.join(p.current, 'pubspec.yaml'));
    final pubspec = await file.readAsString();

    final yaml = loadYaml(pubspec);
    final editor = YamlEditor(pubspec);

    final font = {
      'family': family,
      'fonts': [
        {'asset': './$path'},
      ],
    };

    if (yaml['flutter']?['fonts'] == null) {
      final value = {
        'fonts': [font],
      };

      editor.update(['flutter'], value);
      await file.writeAsString(editor.toString());
      return;
    }

    final fonts = editor.parseAt(['flutter', 'fonts']);
    final exists = fonts.value.any((font) => font['family'] == family) as bool;

    if (!exists) {
      editor.appendToList(['flutter', 'fonts'], font);
      await file.writeAsString(editor.toString());
    }
  }
}

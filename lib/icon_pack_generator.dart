/// An icon font generator for Flutter applications.
library icon_pack_generator;

import 'dart:convert';
import 'dart:io';

import 'package:icon_pack_generator/entities/icon_entity.dart';
import 'package:icon_pack_generator/templates/icon_data_template.dart';
import 'package:icon_pack_generator/templates/icon_pack_ext_template.dart';
import 'package:icon_pack_generator/templates/icon_pack_template.dart';
import 'package:icon_pack_generator/templates/icon_template.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

class IconPackGenerator {
  const IconPackGenerator({
    required this.className,
    required this.packageName,
    required this.iconSource,
    required this.fontTarget,
    required this.classTarget,
  });

  final String className;
  final String packageName;
  final Directory iconSource;
  final Directory fontTarget;
  final Directory classTarget;

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

  Future<List<IconEntity>> genFont() async {
    final name = className.snakeCase;
    final source = p.absolute(iconSource.path);
    final output = p.absolute(fontTarget.path);

    final process = await Process.start(
      'fantasticon',
      runInShell: true,
      [
        source,
        '--name',
        name,
        '--output',
        output,
        '--asset-types',
        'json',
        '--font-types',
        'ttf',
      ],
    );

    await stdout.addStream(
      process.stdout.map((bytes) {
        var message = utf8.decode(bytes);
        if (message == '\x1b[32mDone\x1b[39m\n') {
          message = '\x1b[32mSuccess generated font\x1b[39m\n';
        }

        return utf8.encode(message);
      }),
    );

    final dataFile = File(p.setExtension(p.join(output, name), '.json'));
    final dataString = await dataFile.readAsString();
    final dataMap = jsonDecode(dataString) as Map<String, dynamic>;

    final data = dataMap.entries.map((entry) {
      return IconEntity(code: entry.value as int, name: entry.key);
    }).toList();

    await dataFile.delete();
    return data;
  }

  Future<String> genClass({required List<IconEntity> icons}) async {
    final iconData = IconDataTemplate.generate(
      className: className,
      packageName: packageName,
    );

    final iconPack = icons.map((icon) {
      return IconTemplate.generate(
        icon: icon,
        className: className,
      );
    }).join('\n');

    final iconPackExt = IconPackExtTemplate.generate(
      icons: icons,
      source: iconSource,
      className: className,
    );

    return IconPackTemplate.generate(
      className: className,
      iconData: iconData,
      iconPack: iconPack,
      iconPackExt: iconPackExt,
    );
  }

  Future<void> writeClass(String content) async {
    final name = className.snakeCase;
    final output = p.absolute(classTarget.path);
    final path = p.setExtension(p.join(output, name), '.dart');

    var file = File(path);
    file = await file.create();
    await file.writeAsString(content);
  }
}

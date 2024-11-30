/// An icon font generator for Flutter applications.
library icon_pack_generator;

import 'dart:io';

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
}

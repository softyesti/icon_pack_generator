//
// ignore_for_file: avoid_dynamic_calls, avoid_print

import 'dart:io';

import 'package:icon_pack_generator/icon_pack_generator.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

Future<void> main(List<String> args) async {
  print('[Icon Pack Generator] Loading configurations');
  final generator = await _setup(args.firstOrNull);

  print('[Icon Pack Generator] Generating icon pack font');
  final icons = await generator.genFont();

  print('[Icon Pack Generator] Generating icon pack class');
  final content = await generator.genClass(icons: icons);

  print('[Icon Pack Generator] Writing icon pack class file');
  await generator.writeClass(content);

  print('[Icon Pack Generator] Adding icon pack font to pubspec.yaml');
  await generator.writePubspec();

  print('[Icon Pack Generator] Icon pack generation completed!');
}

Future<IconPackGenerator> _setup(String? path) async {
  final config = File(p.absolute(path ?? 'icon_pack_generator.yaml'));
  final configContent = await config.readAsString();

  final yaml = loadYaml(configContent);

  final className = yaml['icon_pack_generator']!['class_name'] as String;
  final packageName = yaml['icon_pack_generator']!['package_name'] as String;
  final iconSource = yaml['icon_pack_generator']!['icon_source'] as String;
  final fontTarget = yaml['icon_pack_generator']!['font_target'] as String;
  final classTarget = yaml['icon_pack_generator']!['class_target'] as String;

  return IconPackGenerator(
    className: className,
    packageName: packageName,
    iconSource: Directory(p.normalize(p.absolute(iconSource))),
    fontTarget: Directory(p.normalize(p.absolute(fontTarget))),
    classTarget: Directory(p.normalize(p.absolute(classTarget))),
  );
}

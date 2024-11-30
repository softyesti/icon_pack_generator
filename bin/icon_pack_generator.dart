// ignore_for_file: avoid_print

import 'dart:io';

import 'package:icon_pack_generator/icon_pack_generator.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

Future<void> main() async {
  print('[Icon Pack Generator] Loading configurations');
  final generator = await _setup();

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

Future<IconPackGenerator> _setup() async {
  final config = File(p.join(p.current, 'icon_pack_generator.yaml'));
  final configContent = await config.readAsString();

  final yaml = loadYaml(configContent);

  // ignore: avoid_dynamic_calls
  final className = yaml['icon_pack_generator']!['class_name'] as String;
  // ignore: avoid_dynamic_calls
  final packageName = yaml['icon_pack_generator']!['package_name'] as String;
  // ignore: avoid_dynamic_calls
  final iconSource = yaml['icon_pack_generator']!['icon_source'] as String;
  // ignore: avoid_dynamic_calls
  final fontTarget = yaml['icon_pack_generator']!['font_target'] as String;
  // ignore: avoid_dynamic_calls
  final classTarget = yaml['icon_pack_generator']!['class_target'] as String;

  return IconPackGenerator(
    className: className,
    packageName: packageName,
    iconSource: Directory(p.absolute(iconSource)),
    fontTarget: Directory(p.absolute(fontTarget)),
    classTarget: Directory(p.absolute(classTarget)),
  );
}

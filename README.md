# Icon Pack Generator

An icon pack generator from `.svg` files for Flutter applications.

## Features

* Icon pack generation based on configuration file
* Automatic addition of the icon font file in `pubspec.yaml`

## Requirements

* [NodeJS(v11+)](https://nodejs.org/en)
* [fantasticon](https://www.npmjs.com/package/fantasticon/v/1.0.13) node package

## Installation

```bash
flutter pub add -d icon_pack_generator
```

OR

```bash
dart pub global activate icon_pack_generator
```

## Config file

Create the following file in the root of your project: `icon_pack_generator.yaml`

```yaml
icon_pack_generator:
  class_name: ""    # ClassName
  package_name: ""  # package_name

  icon_source: ""   # path/to/folder
  font_target: ""   # path/to/folder
  class_target: ""  # path/to/folder
```

## Usage

Run the following command in the root of your project:

```bash
dart run icon_pack_generator
```

## Credits

* SoftYes TI [\<softyes.com.br\>](https://softyes.com.br)
* João Sereia [\<joao.sereia@softyes.com.br\>](mailto:joao.sereia@softyes.com.br)

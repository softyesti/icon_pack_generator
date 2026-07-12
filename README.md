# IconPackGenerator

A tool for generating icon packs from `.svg` files for Flutter packages.

## 🧰 Features

* Icon preview in the IDE, if supported.
* Icon pack generation based on configuration file.
* Automatic addition of the icon font file in `pubspec.yaml`.

## 🖥️ Requirements

* [NodeJS(v11+)](https://nodejs.org/en).
* [fantasticon](https://www.npmjs.com/package/@twbs/fantasticon) node package.

## 🧑‍💻 Installation

```bash
flutter pub add -d icon_pack_generator
```

OR

```bash
dart pub global activate icon_pack_generator
```

## ⚙️ Config file

Create the following file in the root of your project: `icon_pack_generator.yaml`
or any other file in any other location, as long as it contains the following:

```yaml
icon_pack_generator:
  class_name: ""    # ClassName
  package_name: ""  # package_name

  icon_source: ""   # path/to/folder
  font_target: ""   # path/to/folder
  class_target: ""  # path/to/folder
```

## 💡 Usage

Run the following command in the root of your project:

```bash
dart run icon_pack_generator
```

OR

```bash
dart run icon_pack_generator /path/to/file.yaml
```

## 📜 Credits

* SoftYes TI [\<softyes.com.br\>](https://softyes.com.br)
* João Sereia [\<joao.sereia@softyes.com.br\>](mailto:joao.sereia@softyes.com.br)

.PHONY: run example upgrade

default: run

run:
	@echo "Running application"
	@fvm dart run ./bin/icon_pack_generator.dart 

example:
	@echo "Running example"
	@fvm dart run ./example/icon_pack_generator_example.dart
 
upgrade:
	@echo "Upgrading dependencies..."
	@fvm dart pub upgrade
	@fvm dart pub upgrade --major-versions

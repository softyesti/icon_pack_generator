.PHONY: run example

default: run

run:
	@echo "Running application"
	@dart run ./bin/icon_pack_generator.dart 

example:
	@echo "Running example"
	@dart run ./example/icon_pack_generator_example.dart
 
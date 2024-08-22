.PHONY: run

default: run

run:
	@echo "Running application"
	@dart run ./bin/soft_icon_gen.dart 

example:
	@echo "Running example"
	@dart run ./example/soft_icon_gen_example.dart
 
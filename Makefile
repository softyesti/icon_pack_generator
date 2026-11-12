.PHONY: deps run example upgrade

default: run

deps:
	@echo "Installing dependencies..."
	@npm install

run:
	@echo "Running application..."
	@dart run ./bin/icon_pack_generator.dart 

example:
	@echo "Running the example..."
	@dart run ./example/icon_pack_generator_example.dart
 
upgrade:
	@echo "Upgrading dependencies..."
	@dart pub upgrade
	@dart pub upgrade --major-versions


run: build
	node build/server.js

build: clean
	coffee -c -o build/ src/




clean:
	rm -rf build/*

.PHONY: clean build run

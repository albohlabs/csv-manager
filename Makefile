EXEC_PATH:=$(shell stack path --local-install-root)
PROJECT_NAME:=csv-manager
PROJECT_PATH:=$(realpath $(shell pwd))

setup:
	stack setup
	stack build
	stack build --copy-compiler-tool hlint stan weeder

build:
	stack build --pedantic
	mkdir -p ./dist
	cp $(EXEC_PATH)/bin/$(PROJECT_NAME) ./dist

	strip ./dist/$(PROJECT_NAME)
	# upx ./dist/$(PROJECT_NAME)

build-dev:
	stack build 
	mkdir -p ./dist
	cp $(EXEC_PATH)/bin/$(PROJECT_NAME) ../csv-manager-ui

dev:
	stack build --file-watch --fast

lint:
	stack exec stan
	stack exec hlint src
	stack exec weeder 

.SILENT: all clean build

all: clean build

clean:
	rm -rf _build dark_hand .elixir_ls

build:
	mix escript.build
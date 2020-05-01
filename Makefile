.SILENT: clean build test

all: clean build

clean:
	rm -rf _build dark_hand .elixir_ls

build:
	mix escript.build

tests:
	mix test

unit:
	mix test --only unit

exploratory:
	mix test --only exploratory

t: tests

u: unit

e: exploratory
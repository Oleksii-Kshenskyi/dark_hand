.SILENT: clean deps build test

all: clean deps build

clean:
	rm -rf _build dark_hand .elixir_ls deps

deps:
	mix deps.get

build:
	mix escript.build

tests:
	mix test

unit:
	mix test --only unit

unitfast:
	mix test --only unitfast

exploratory:
	mix test --only exploratory

b: build

t: tests

u: unit

uf: unitfast

e: exploratory

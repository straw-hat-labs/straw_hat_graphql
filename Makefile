deps:
	mix local.hex --force
	mix local.rebar --force
	mix deps.get

testing: deps
	mix credo
	mix format --check-formatted
	mix coveralls.travis

docs:
	mix inch.report


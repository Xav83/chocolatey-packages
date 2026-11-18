.PHONY: format lint

# Format the Python scripts (black) and apply ruff's automatic fixes.
format:
	black scripts ops
	ruff check --fix scripts ops

# Check the Python scripts, the spelling and the workflows' security (same checks as CI,
# zizmor without its online audits).
lint:
	black --check scripts ops
	ruff check scripts ops
	codespell
	zizmor --offline .

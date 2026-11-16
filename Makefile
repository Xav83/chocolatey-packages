.PHONY: format lint

# Format the Python scripts (black) and apply ruff's automatic fixes.
format:
	black scripts ops
	ruff check --fix scripts ops

# Check the Python scripts without changing them (same checks as CI).
lint:
	black --check scripts ops
	ruff check scripts ops

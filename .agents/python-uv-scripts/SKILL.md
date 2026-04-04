---
name: python-uv-scripts
description: |
  How to create Python scripts using uv for this project. Use this skill whenever 
  the user wants to create, modify, or write Python scripts in this repository 
  that should be executable with `uv run`. This includes new utility scripts, 
  CLI tools, or any standalone Python executables that use the project's conventions.
---

# Python UV Scripts

This skill defines how to create Python scripts using `uv` according to this project's conventions.

## Shebang

Always use the uv script shebang:

```python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = []
# ///
```

The dependencies array should include any required packages (e.g., `["click", "requests"]`).

## File Structure

```python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["click"]
# ///

import argparse
from pathlib import Path
import sys

import click


def main() -> None:
    parser = argparse.ArgumentParser(description="...")
    parser.add_argument("files", nargs="+", help="Input file(s)")
    parser.add_argument("-o", "--output", help="Output file")
    args = parser.parse_args()


if __name__ == "__main__":
    main()
```

## Import Order

1. Standard library (`argparse`, `pathlib`, `sys`, `subprocess`, etc.)
2. Third-party packages (`click`, `requests`, etc.)
3. Local imports (from this project)

## Type Hints

Always use type hints for function signatures:

```python
def process_file(input_path: Path, output_path: Path) -> bool:
    ...

def main() -> None:
    ...
```

## Naming Conventions

- Functions and variables: `snake_case`
- Classes: `PascalCase`

## Error Handling

Use try/except with specific exceptions and `click` for CLI output:

```python
def process_file(input_path: Path) -> bool:
    try:
        with open(input_path) as f:
            f.read()
    except FileNotFoundError as e:
        click.secho(f"Error: {e}", fg="red", err=True)
        return False
    except PermissionError as e:
        click.secho(f"Permission denied: {e}", fg="red", err=True)
        return False
    return True
```

## Strings

- Use f-strings for string interpolation
- Prefer double quotes

```python
click.echo(f"Processing {input_path.name}")
message = "File not found"
```

## Formatting

- Line length: 100 characters
- Use ruff for formatting: `ruff format <file>`

## Linting

Run ruff check: `ruff check <file>`

## CLI Patterns

Use `click` for CLI output and argument parsing:

```python
import click

@click.command()
@click.argument("input_file", type=click.Path(exists=True))
@click.option("-o", "--output", type=click.Path(), help="Output file")
def main(input_file: str, output: str | None) -> None:
    """Process INPUT_FILE."""
    click.echo(f"Processing {input_file}")
    if output:
        click.echo(f"Output to {output}")
```

## Running Scripts

```bash
uv run convert.py --help
uv run enrich_json.py --input data.json
uv run --python 3.11 script.py
```

## Examples

### Simple script structure

```python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["click"]
# ///

from pathlib import Path
import sys

import click


def validate_file(path: Path) -> bool:
    if not path.exists():
        click.secho(f"Error: {path} not found", fg="red", err=True)
        return False
    if not path.is_file():
        click.secho(f"Error: {path} is not a file", fg="red", err=True)
        return False
    return True


def main() -> None:
    input_path = Path(sys.argv[1])
    if validate_file(input_path):
        click.echo(f"Processing {input_path}")


if __name__ == "__main__":
    main()
```

### Script with error handling

```python
#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["click", "requests"]
# ///

from pathlib import Path
import sys

import click
import requests


def download_file(url: str, output_path: Path) -> bool:
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        output_path.write_bytes(response.content)
    except requests.RequestException as e:
        click.secho(f"Download failed: {e}", fg="red", err=True)
        return False
    return True


def main() -> None:
    url = sys.argv[1]
    output = Path(sys.argv[2])
    if download_file(url, output):
        click.echo(f"Downloaded to {output}")


if __name__ == "__main__":
    main()
```

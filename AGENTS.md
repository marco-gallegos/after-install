# AGENTS.md - Guidelines for Agents

This is a dotfiles/setup scripts repository containing shell installation scripts for various Linux distributions and macOS, plus a few Python utility scripts.

## Project Structure

- `*.sh` - Installation scripts for different OSes (fedora32.sh, manjaro.sh, ubuntu.sh, etc.)
- `bash/`, `nvim/`, `alacritty/`, `kitty/`, `zsh/` - Configuration directories
- `bin/` - Utility scripts
- `convert.py`, `enrich_json.py` - Python utilities (use `uv run`)

## Build/Lint/Test Commands

### Python Scripts

```bash
# Run a single Python script with uv
uv run convert.py --help
uv run enrich_json.py --help

# Run with specific Python version
uv run --python 3.11 convert.py file.mp4

# Linting (if ruff installed)
ruff check convert.py enrich_json.py

# Format code
ruff format convert.py enrich_json.py
```

### Shell Scripts

```bash
# Shellcheck linting
shellcheck fedora32.sh manjaro.sh ubuntu.sh

# Check a specific script
shellcheck bin/bak
```

### General

```bash
# Syntax check all shell scripts
for f in *.sh bin/*; do bash -n "$f" || echo "Error in $f"; done
```

## Code Style Guidelines

### Python

- **Interpreter**: Use `uv run --script` shebang for executable scripts
- **Formatting**: Use ruff for formatting (line length 100)
- **Imports**: Standard library first, then third-party, then local
- **Types**: Use type hints for function signatures
- **Naming**: `snake_case` for functions/variables, `PascalCase` for classes
- **Error Handling**: Use try/except with specific exceptions, use `click` for CLI output
- **Strings**: Use f-strings, prefer double quotes

Example:
```python
from pathlib import Path
import sys

import click

def process_file(input_path: Path) -> bool:
    try:
        # ...
    except FileNotFoundError as e:
        click.secho(f"Error: {e}", fg="red", err=True)
        return False
    return True
```

### Shell Scripts

- **Shebang**: `#!/bin/bash` or `#!/usr/bin/env bash`
- **ShellCheck**: Validate all scripts with shellcheck
- **Variable quoting**: Always quote variables (`"$var"` not `$var`)
- **Functions**: Use `function name` or `name()` syntax consistently
- **Error handling**: Use `set -euo pipefail`
- **Exit codes**: Explicit `exit 0` or `exit 1`

Example:
```bash
#!/bin/bash
set -euo pipefail

function backup_file() {
    local filename="$1"
    local newfile="${filename}.bak"
    cp "$filename" "$newfile"
}

backup_file "$1"
```

### Configuration Files

- Neovim: Lua-based in `nvim/lua/`, vimscript in `nvim/.vimrc`
- Shell configs: `.bashrc`, `.zshrc` - follow shell script guidelines
- Terminal configs: YAML/TOML formats - maintain consistency with existing style

### General

- No TODOs in final code unless truly necessary
- Use comments sparingly - code should be self-documenting
- Keep files under 500 lines when possible
- Use meaningful variable/function names (no single letters except in loops)

## Common Operations

### Running Installation Scripts

```bash
# Fedora
sudo bash fedora33.sh

# Ubuntu
bash ubuntu.sh

# macOS
bash osx_monterrey.sh
```

### Using dotfiles with GNU Stow

```bash
# Link a module to home directory
stow -vt ~ bash

# Unlink
stow -Dv -t ~ bash
```

## Dependencies

- Python scripts use `uv` for execution
- Requirements in `requirements.txt` for pip-installed tools
- Shell scripts rely on system package managers (apt, dnf, brew)

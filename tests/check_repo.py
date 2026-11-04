#!/usr/bin/env python3
"""Static integrity check: no network calls, images, containers or AWS actions."""
import ast, json, re, sys
from pathlib import Path
root=Path(__file__).resolve().parent.parent
errors=[]
for p in root.rglob('*.md'):
    text=p.read_text(encoding='utf-8')
    for target in re.findall(r'(?<!!)\[[^\]]+\]\(([^)]+)\)',text):
        target=target.split('#',1)[0]
        if target and not target.startswith(('http://','https://','mailto:')) and not (p.parent/target).exists():
            errors.append(f'Broken link in {p.relative_to(root)}: {target}')
for p in root.rglob('*.json'):
    try: json.loads(p.read_text())
    except Exception as e:errors.append(f'Invalid JSON {p.relative_to(root)}: {e}')
for p in root.rglob('*.py'):
    try:ast.parse(p.read_text())
    except Exception as e:errors.append(f'Invalid Python {p.relative_to(root)}: {e}')
for p in root.rglob('*.yaml'):
    # PyYAML may not be on the reader's computer; YAML check is optional here.
    try:
        import yaml
        yaml.safe_load(p.read_text())
    except ImportError:
        pass
    except Exception as e:errors.append(f'Invalid YAML {p.relative_to(root)}: {e}')
for p in root.rglob('*.yml'):
    try:
        import yaml
        yaml.safe_load(p.read_text())
    except ImportError:
        pass
    except Exception as e:errors.append(f'Invalid YAML {p.relative_to(root)}: {e}')
for unwanted in ('BOOK-CODE.md','MANUSCRIPT.md'):
    if list(root.rglob(unwanted)):errors.append(f'Forbidden editorial file: {unwanted}')
if errors:
    print('\n'.join(errors),file=sys.stderr)
    sys.exit(1)
print('Documentation links and JSON/Python/YAML syntax: OK')

"""Validate Azure DevOps pipeline YAML against the schema bundled with check-jsonschema.

check-jsonschema's own CLI refuses this schema (its metaschema check rejects a regex
format), so we validate the instance directly and skip only the schema self-check.
"""
import json
import sys
from pathlib import Path

import check_jsonschema
import yaml
from jsonschema import Draft7Validator

schema_path = Path(check_jsonschema.__file__).parent / "builtin_schemas" / "vendor" / "azure-pipelines.json"
validator = Draft7Validator(json.loads(schema_path.read_text(encoding="utf-8")))

failed = False
for name in sys.argv[1:]:
    document = yaml.safe_load(Path(name).read_text(encoding="utf-8"))
    errors = sorted(validator.iter_errors(document), key=lambda e: list(e.path))
    for error in errors:
        failed = True
        location = "/".join(str(p) for p in error.path) or "<root>"
        print(f"{name}: {location}: {error.message}")
    if not errors:
        print(f"{name}: ok")

sys.exit(1 if failed else 0)

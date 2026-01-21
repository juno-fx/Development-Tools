#!/usr/bin/env bash

set -euo pipefail

if [[ -n "${IN_CI:-}" ]]; then
    CHANGED=0
    for FILE in .kind.yaml .kind.yaml.patched skaffold.yaml; do
      [[ -f "$FILE" ]] || continue

      # Make a backup to detect changes
      cp "$FILE" "$FILE.bak"

      # Apply sed replacements
      sed -i -E \
        -e 's/^( *hostPort: *)80$/\18080/' \
        -e 's/^( *hostPort: *)443$/\18443/' \
        -e 's/^( *localPort: *)80$/\18080/' \
        -e 's/^( *localPort: *)443$/\18443/' \
        "$FILE"

      # Check if file changed
      if ! cmp -s "$FILE" "$FILE.bak"; then
        echo "CHANGED $FILE: UPDATED RESERVED PORTS"
        CHANGED=1
      fi

      # Remove backup
      rm -f "$FILE.bak"
    done
fi

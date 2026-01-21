#!/usr/bin/env bash
#
# patch-kind-config.sh — minimal extraMounts injector; outputs .kind.yaml.patched

set -euo pipefail

in="$1"
patched=".kind.yaml.patched"
dc="$HOME/.docker/config.json"

# Copy input to patched
cp "$in" "$patched"

# Only proceed if docker config exists, extraMounts exists, and not already present
if [[ -f "$dc" ]] && grep -q 'extraMounts:' "$patched" && ! grep -q 'containerPath: /var/lib/kubelet/config.json' "$patched"; then

    # detect indent of first "- hostPath:" under extraMounts
    indent="$(awk '/extraMounts:/ { f=1; next } f && /- hostPath:/ {
        match($0,/^[[:space:]]*/)
        print substr($0,RSTART,RLENGTH)
        exit
    }' "$patched")"

    # fallback indent if detection fails
    [[ -z "$indent" ]] && indent="      "

    # inject mount after *every* extraMounts:
    awk -v dc="$dc" -v ind="$indent" '
    /^[[:space:]]*extraMounts:/ {
        print
        print ind "- hostPath: \"" dc "\""
        print ind "  containerPath: /var/lib/kubelet/config.json"
        next
    }
    { print }
    ' "$patched" > "$patched.tmp" && mv "$patched.tmp" "$patched"

    echo ">> patch-kind-config: injected docker config mount(s)"

else
    echo ">> patch-kind-config: no change needed"
fi

if [[ -n "${IN_CI:-}" ]]; then
    CHANGED=0
    for FILE in .kind.yaml skaffold.yaml; do
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

echo ">> patch-kind-config: output -> $patched"

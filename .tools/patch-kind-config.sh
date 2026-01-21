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

echo ">> patch-kind-config: output -> $patched"

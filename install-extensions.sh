#!/usr/bin/env bash
set -euo pipefail

# Usage: install-extensions.sh "ext-id-1,ext-id-2,ext-id-3"
# Reads a comma-separated list of VS Code extension IDs and installs
# each one via the `code` CLI, skipping blanks and trimming whitespace.

EXTENSIONS_RAW="${1:-${VSCODE_EXTENSIONS:-}}"

if [[ -z "${EXTENSIONS_RAW}" ]]; then
  echo "[install-extensions] No extensions provided. Skipping."
  exit 0
fi

# Split on commas into an array, trimming whitespace from each entry
IFS=',' read -ra RAW_LIST <<< "${EXTENSIONS_RAW}"

EXTENSIONS=()
for item in "${RAW_LIST[@]}"; do
  trimmed="$(echo "${item}" | xargs)"
  [[ -n "${trimmed}" ]] && EXTENSIONS+=("${trimmed}")
done

if [[ "${#EXTENSIONS[@]}" -eq 0 ]]; then
  echo "[install-extensions] Extension list was empty after parsing. Skipping."
  exit 0
fi

echo "[install-extensions] Installing ${#EXTENSIONS[@]} extension(s):"
printf '  - %s\n' "${EXTENSIONS[@]}"

FAILED=()
for ext in "${EXTENSIONS[@]}"; do
  echo "[install-extensions] Installing: ${ext}"
  if ! code --install-extension "${ext}" --force; then
    echo "[install-extensions] WARNING: failed to install ${ext}"
    FAILED+=("${ext}")
  fi
done

if [[ "${#FAILED[@]}" -gt 0 ]]; then
  echo "[install-extensions] The following extensions failed to install:"
  printf '  - %s\n' "${FAILED[@]}"
  exit 1
fi

echo "[install-extensions] Done."

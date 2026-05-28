#!/usr/bin/env bash
# deploy.sh — build the Hugo site and publish it to /var/www/cajunhacker.
#
# Usage:
#   ./deploy.sh            # build and deploy
#   ./deploy.sh --dry-run  # build and show what would change, without copying
#
# What this does, in order:
#   1. hugo --minify              (build static output to ./public/)
#   2. rsync public/ -> /var/www/cajunhacker/     (with --delete)
#   3. chown -R www-data:www-data /var/www/cajunhacker
#   4. nginx -t                   (validate config)
#   5. systemctl reload nginx     (only if -t passed)
#
# The rsync uses --delete: files in /var/www/cajunhacker that are not in
# public/ will be removed. This is intentional (keeps the deployed site
# in sync with the source). Renames produce removals + additions.

set -euo pipefail

SRC_DIR="$HOME/sites/cajunhacker"
WEB_ROOT="/var/www/cajunhacker"
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --dry-run|-n) DRY_RUN=1 ;;
    -h|--help)
      sed -n '1,20p' "$0" | sed -e 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 2
      ;;
  esac
done

cd "$SRC_DIR"

echo "[+] Building Hugo site (hugo --minify)..."
hugo --minify

if [[ ! -d "$SRC_DIR/public" ]]; then
  echo "[-] Build output ${SRC_DIR}/public does not exist. Aborting." >&2
  exit 1
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "[+] DRY RUN: showing what rsync would change..."
  sudo rsync -avn --delete "$SRC_DIR/public/" "$WEB_ROOT/"
  echo "[+] DRY RUN complete. No files copied. No services reloaded."
  exit 0
fi

echo "[+] Publishing to ${WEB_ROOT}..."
sudo rsync -av --delete "$SRC_DIR/public/" "$WEB_ROOT/"

echo "[+] Setting ownership to www-data:www-data..."
sudo chown -R www-data:www-data "$WEB_ROOT"

echo "[+] Validating Nginx config..."
sudo nginx -t

echo "[+] Reloading Nginx..."
sudo systemctl reload nginx

echo "[+] Done. Site deployed to ${WEB_ROOT}."

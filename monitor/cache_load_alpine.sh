#!/usr/bin/env bash
# usage: ./cache_load_alpine.sh [path] [size_mb]
set -euo pipefail
F="${1:-/tmp/pcdemo.bin}"
SZ="${2:-20}"

[ -f "$F" ] || dd if=/dev/urandom of="$F" bs=1M count="$SZ" status=none

echo "file:  $F"
echo "inode: $(stat -c '%i' "$F")"
echo "size:  ${SZ} MiB ($(( SZ * 1024 / 4 )) pages)"
echo

trap 'echo; echo stopped; exit 0' INT
while true; do
    echo "[$(date +%T)] EVICT"
    vmtouch -e "$F" >/dev/null
    sleep 1
    echo "[$(date +%T)] READ"
    dd if="$F" of=/dev/null bs=1M status=none
    sleep 3
done

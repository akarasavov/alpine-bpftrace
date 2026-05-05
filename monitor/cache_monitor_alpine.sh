#!/usr/bin/env bash
# usage: bash cache_monitor_alpine.sh <file>
# note: must run as root or with --privileged in Docker
set -euo pipefail
F="${1:?file required}"
INO=$(stat -c '%i' "$F")
PAGESZ=$(getconf PAGE_SIZE 2>/dev/null || echo 4096)
echo "watching inode $INO ($F), page size $PAGESZ bytes"

bpftrace -e '
tracepoint:filemap:mm_filemap_add_to_page_cache / args->i_ino == $1 / {
    @misses += 1;
}

interval:s:1 {
    time("%H:%M:%S ");
    printf(" pages_loaded=%-8d  total_bytes=%d\n", @misses, @misses * $2);
    clear(@misses);
}
' $INO $PAGESZ

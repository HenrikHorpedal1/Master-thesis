#!/bin/bash
# Wrapper for pdflatex: removes corrupted aux/out before each run.
# A truncated aux file (missing the final \relax) causes "File ended while
# scanning use of \@writefile" — this happens when pdflatex is killed mid-write
# by VimTeX restarting compilation on save.
AUX="build/main.aux"
OUT="build/main.out"

if [ -f "$AUX" ] && [ -s "$AUX" ]; then
    if ! tail -c 100 "$AUX" | grep -qE '\\relax|\\gdef'; then
        echo "texrun: corrupted aux detected — removing build/main.{aux,out,toc}" >&2
        rm -f "$AUX" "$OUT" "build/main.toc"
    fi
fi

exec pdflatex "$@"

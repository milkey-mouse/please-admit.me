#!/bin/bash

# TODO: add to git commit hook & only process new/edited images

PARALLEL=1
ALGORITHM=lanczos
QUALITY=1 # from 1-31 (lower is better)

function resize() {
    echo "$1"  # edit tracking for warnings later
    echo resize $* 1>&2
    (
        # TODO: never resize larger
        ffmpeg -hide_banner -nostdin -loglevel warning -i "assets/originals/$1" -vf scale=w="$2":h="$3":force_original_aspect_ratio="${CROP:-increase}":flags="${ALGORITHM:lanczos}" -compression_level 100 -q:v "${QUALITY}" -n -- "assets/$1"
    ) &
    [ "${PARALLEL}" == "1" ] || wait
}

function optimize() {
    echo "$1"
    echo optimize "$*" 1>&2
    [ -e "assets/$1" ] || ps2pdf "assets/originals/$1" "assets/$1"
}

TMP="$(mktemp)"

(
    # thumbnails
    while IFS=$'\n' read -r f; do
        resize "$f" 640 360
    done < <(
        find . -type f \( -name '*.md' -o -name '*.html' \) \
        -execdir grep -Pho "(?<=^image: /assets/).*$" {} \;
    )

    # in posts
    while IFS=$'\n' read -r f; do
        resize "$f" 650 -1
    done < <(
        find . -type f -name '*.md' \
        -execdir sed -n 's/^\!\[.*\](\/assets\/\(.*\))$/\1/p' {} \;
    )

    # main page hero image
    CROP=decrease QUALITY=5 resize sammammish-slough.jpg 1920 1000

    # PDFs
    # https://www.shellhacks.com/linux-compress-pdf-reduce-pdf-size/
    while IFS=$'\n' read -r f; do
        optimize "$f"
    done < <(find assets/originals -type f -name '*.pdf' | cut -d/ -f3-)

    wait
) | sort -u > "$TMP"

CODE=0
while IFS=$'\n' read -r f; do
    echo "File $f is untouched" 1>&2
    CODE=1
done < <(find assets/originals -type f | cut -d/ -f3- | sort | comm -23 - "$TMP")

du -Ssch assets/originals assets

rm "$TMP"
exit $CODE

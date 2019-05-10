#!/bin/bash

PARALLEL=1
ALGORITHM=lanczos
QUALITY=80 # from 1-100

function resize() {
    echo "$1"  # edit tracking for warnings later
    echo resize $* 1>&2
    (
        case "$1" in
        "*.jpg")
          ffmpeg -hide_banner -nostdin -loglevel warning -i "assets/originals/$1" \
          -vf scale=w="$2":h="$3":force_original_aspect_ratio="${CROP:-increase}":flags="${ALGORITHM:lanczos}" -f tga - | \
          cjpeg -targa -optimize -progressive -quality "${QUALITY}" -outfile "assets/$1"
          ;;
        "*")
          ffmpeg -hide_banner -nostdin -loglevel warning -i "assets/originals/$1" \
          -vf scale=w="$2":h="$3":force_original_aspect_ratio="${CROP:-increase}":flags="${ALGORITHM:lanczos}" \
          -compression_level 100 -y "assets/$1"
          ;;
        esac

        # TODO: never resize larger
    ) &
    [ "${PARALLEL}" == "1" ] || wait
}

function optimize() {
    echo "$1"
    echo optimize $* 1>&2
    case "$1" in
      "*.pdf")
        ps2pdf "assets/originals/$1" "assets/$1"
        ;;
      "*.png")
        # TODO
        ;;
    esac
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

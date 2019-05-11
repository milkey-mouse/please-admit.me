#!/bin/bash


git diff --name-only --cached -z | grep -z '\.md$' | xargs -0rn1 \
sh -c 'sed -i "/^anchors: true$/d" "$1"; sed "2,/^---$/ d" "$1" | grep -q "^#" && sed -i "0,/^---$/! {0,/^---$/ s/^---$/anchors: true\n---/}" "$1"; git add "$1"' sh

# remove EXIF and other metadata from photos & other media (sometimes this even includes geotags!)
git diff --name-only --cached -z assets | xargs -0rn1 sh -c 'exiftool -all= -overwrite_original "$1" && git add "$1"' sh

# PDFs must be linearized or deletion is reversible
git diff --name-only --cached -z assets | grep -z '\.pdf$' | xargs -0rn1 sh -c 'qpdf --linearize "$1" && git add "$1"' sh

# don't commit if build fails
# TODO: this checks the working dir version, not the staged version
TMPDIR="$(mktemp -p /tmp -d jekyll-XXXXX)"
bundle exec jekyll build "${TMPDIR}"
CODE=$?

rm -r "${TMPDIR}"

# all assets should have a small version for direct use & a large version on clickthrough
while IFS= read -rd "" f; do
    if [ -e "assets/original/$f" ]; then
        (echo "Media assets/original/$f has no shrunk/optimized counterpart" 1>&2)
    else
        (echo "Media assets/$f has no original counterpart" 1>&2)
    fi
    if grep -qE '\.(png|jpg)$' <<<"$f"; then
        # it's OK for a video or SVG not to have an optimized version
        CODE=1
    fi
done < <(git ls-files -z assets | grep -zE '\.(png|jpg)$' | sed -z 's#^assets/\(originals/\)\?##' | sort -z | uniq -uz)

exit ${CODE}

#!/bin/bash

git diff --name-only --cached assets | xargs -r exiftool -all= -overwrite_original
git diff --name-only --cached assets | grep '.pdf$' | xargs -r qpdf --linearize
git diff --name-only --cached assets | xargs -r git add

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

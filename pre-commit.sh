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
    CODE=1
    if fn="$(find ./assets/original -type f -name "$f.*")"; then
        echo "Media $fn has no shrunk/optimized counterpart"
    elif fn="$(find ./assets -type f -name "$f.*")"; then
        echo "Media $fn has no original counterpart"
    fi
done 1>&2 < <(git ls-files -z assets | grep -zE '\.(png|jpg)$' | sed -z 's#^assets/\(originals/\)\?##;s#^\(.*\)\..*$#\1#' | sort -z | uniq -uz)

exit ${CODE}

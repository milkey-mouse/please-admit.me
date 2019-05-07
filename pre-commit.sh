#!/bin/sh

git diff --name-only --cached assets | xargs -r exiftool -all= -overwrite_original
git diff --name-only --cached assets | grep '.pdf$' | xargs -r qpdf --linearize
git diff --name-only --cached assets | xargs -r git add

# don't commit if build fails
# TODO: this checks the working dir version, not the staged version
TMPDIR="$(mktemp -p /tmp -d jekyll-XXXXX)"
bundle exec jekyll build "${TMPDIR}"
CODE=$?

rm -r "${TMPDIR}"

exit ${CODE}

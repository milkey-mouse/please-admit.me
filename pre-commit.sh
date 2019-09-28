#!/bin/bash

exit 0

# add _grade tag to put grade # in rendered date
git diff --name-only --cached -z _projects | grep -z '\.md$' | \
while IFS= read -rd "" f; do
    sed -i "/^_grade: [0-9]*$/d" "$f"
    TIMESTAMP="$(date --date="$(printf "%s" "$f" | cut -d/ -f2 | cut -d- -f1-3)" '+%s')"
    if [ $TIMESTAMP -gt $(date --date="2020-09-01" '+%s') ]; then
        GRADE=12
    elif [ $TIMESTAMP -gt $(date --date="2018-09-01" '+%s') ]; then
        GRADE=11
    elif [ $TIMESTAMP -gt $(date --date="2017-09-01" '+%s') ]; then
        GRADE=10
    elif [ $TIMESTAMP -gt $(date --date="2016-09-01" '+%s') ]; then
        GRADE=9
    elif [ $TIMESTAMP -gt $(date --date="2015-09-01" '+%s') ]; then
        GRADE=8
    elif [ $TIMESTAMP -gt $(date --date="2014-09-01" '+%s') ]; then
        GRADE=6
    elif [ $TIMESTAMP -gt $(date --date="2013-09-01" '+%s') ]; then
        GRADE=5
    elif [ $TIMESTAMP -gt $(date --date="2012-09-01" '+%s') ]; then
        GRADE=4
    elif [ $TIMESTAMP -gt $(date --date="2011-09-01" '+%s') ]; then
        GRADE=3
    elif [ $TIMESTAMP -gt $(date --date="2010-09-01" '+%s') ]; then
        GRADE=2
    elif [ $TIMESTAMP -gt $(date --date="2009-09-01" '+%s') ]; then
        GRADE=1
    else
        echo "Warning: $f has no grade in front matter" 1>&2
        exit 1
    fi
    sed -i "0,/^---$/! {0,/^---$/ s/^---$/_grade: $GRADE\n---/}" "$f"
    git add "$f"
done

# add _anchors tag to include anchors.js
git diff --name-only --cached -z | grep -z '\.md$' | \
while IFS= read -rd "" f; do
    sed -i "/^_anchors: true$/d" "$f"
    if sed "2,/^---$/ d" "$f" | grep -q "^#"; then
        sed -i "0,/^---$/! {0,/^---$/ s/^---$/_anchors: true\n---/}" "$f"
    fi
    git add "$f"
done

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
    CODE=1
    if fn="$(find ./assets/original -type f -name "$f.*")"; then
        echo "Media $fn has no shrunk/optimized counterpart"
    elif fn="$(find ./assets -type f -name "$f.*")"; then
        echo "Media $fn has no original counterpart"
    fi
done 1>&2 < <(git ls-files -z assets | grep -zE '\.(png|jpg)$' | sed -z 's#^assets/\(originals/\)\?##;s#^\(.*\)\..*$#\1#' | sort -z | uniq -uz)

exit ${CODE}

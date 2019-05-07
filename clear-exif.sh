#!/bin/sh


git diff --name-only --cached assets | xargs -r exiftool -all= -overwrite_original
git diff --name-only --cached assets | grep '.pdf$' | xargs -r qpdf --linearize
git diff --name-only --cached assets | xargs -r git add

exit

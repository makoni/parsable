#!/bin/bash

swift package --allow-writing-to-directory ~/Downloads \
    generate-documentation \
    --target Parsable \
    --disable-indexing \
    --output-path ~/Downloads/parsable \
    --transform-for-static-hosting \
    --hosting-base-path docs/parsable

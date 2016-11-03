#!/bin/bash

while true; do
  case "$1" in
    --strings ) STRINGS=$2; shift; shift ;;
    --stringsdict ) STRINGS_DICT=$2; shift; shift ;;
    --strings-src ) STRINGS_SRC=$2; shift; shift ;;

    --storyboards-dir) STORYBOARDS_DIR=$2; shift; shift ;;
    --storyboards-src) STORYBOARDS_SRC=$2; shift; shift ;;

    --imageset) IMAGESET=$2; shift; shift ;;
    --images-src) IMAGES_SRC=$2; shift; shift ;;

    * ) break ;;
  esac
done

DIR=`dirname "$0"`
if [ -n "$STRINGS_SRC" ]; then
	"$DIR/genswiftstrings.swift" "$STRINGS" "$STRINGS_SRC" "$STRINGS_DICT"
fi

if [ -n "$STORYBOARDS_SRC" ]; then
	find "$STORYBOARDS_DIR" -name "*.storyboard" -print0 | xargs -0 "$DIR/genswiftstoryboards.swift" "$STORYBOARDS_SRC"
fi

if [ -n "$IMAGES_SRC" ]; then
	find "$IMAGESET" -name "*.imageset" -print0 | xargs -0 "$DIR/genswiftimages.swift" "$IMAGES_SRC"
fi

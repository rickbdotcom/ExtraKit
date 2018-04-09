#!/bin/bash

while true; do
  case "$1" in
    --strings ) STRINGS=$2; shift; shift ;;
    --stringsdict ) STRINGS_DICT=$2; shift; shift ;;
    --strings-src ) STRINGS_SRC=$2; shift; shift ;;
    --strings-enum ) STRINGS_ENUM=$2; shift; shift ;;
    --strings-table ) STRINGS_TABLE=$2; shift; shift ;;

    --storyboards-dir) STORYBOARDS_DIR=$2; shift; shift ;;
    --storyboards-src) STORYBOARDS_SRC=$2; shift; shift ;;
    --storyboards-struct) STORYBOARDS_STRUCT=$2; shift; shift ;;

    --fonts-dir) FONTS_DIR=$2; shift; shift ;;
    --fonts-src) FONTS_SRC=$2; shift; shift ;;
    --fonts-enum) FONTS_ENUM=$2; shift; shift ;;

	--info-plist) INFO_PLIST=$2; shift; shift ;;

    --nibs-dir) NIBS_DIR=$2; shift; shift ;;
    --nibs-src) NIBS_SRC=$2; shift; shift ;;
    --nibs-enum) NIBS_ENUM=$2; shift; shift ;;

    --xcassets) XCASSETS=$2; shift; shift ;;
    --colors-src) COLORS_SRC=$2; shift; shift ;;
    --colors-enum) COLORS_ENUM=$2; shift; shift ;;
    * ) break ;;
  esac
done

DIR=`dirname "$0"`

if [ -n "$STRINGS_SRC" ]; then
	"$DIR/genswiftstrings.swift" "$STRINGS" "$STRINGS_SRC" "$STRINGS_DICT" "$STRINGS_ENUM" "$STRINGS_TABLE"
fi

if [ -n "$STORYBOARDS_SRC" ]; then
	find "$STORYBOARDS_DIR" -type f -iname "*.storyboard" -print0 | xargs -0 "$DIR/genswiftstoryboards.swift"  "$STORYBOARDS_SRC" "$STORYBOARDS_STRUCT"
fi

if [ -n "$FONTS_SRC" ]; then
	"$DIR/genswiftfonts.swift" "$FONTS_SRC" "$FONTS_ENUM" "$FONTS_DIR" "$INFO_PLIST"
fi

if [ -n "$NIBS_SRC" ]; then
	"$DIR/genswiftnibs.swift" "$NIBS_SRC" "$NIBS_ENUM" "$NIBS_DIR"
fi

if [ -n "$COLORS_SRC" ]; then
	"$DIR/genswiftcolors.swift" "$COLORS_SRC" "$COLORS_ENUM" "$XCASSETS" 
fi

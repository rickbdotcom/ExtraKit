#!/bin/bash

# since Swift doesn't have any easy way to parse getopt long arguments or import dependencies in scripts we just leverage the shell here
# when/if this changes, remove this script and put functionality in individual scripts

while true; do
  case "$1" in
    --strings ) STRINGS=$2; shift; shift ;;
    --stringsdict ) STRINGS_DICT=$2; shift; shift ;;
    --strings-src ) STRINGS_SRC=$2; shift; shift ;;
    --strings-enum ) STRINGS_ENUM=$2; shift; shift ;;
    --strings-table ) STRINGS_TABLE=$2; shift; shift ;;

    --storyboards-dir) STORYBOARDS_DIR=$2; shift; shift ;;
    --storyboards-src) STORYBOARDS_SRC=$2; shift; shift ;;
	--storyboards-import) STORYBOARDS_IMPORT=$2; shift; shift ;;
	
    --fonts-dir) FONTS_DIR=$2; shift; shift ;;
    --fonts-src) FONTS_SRC=$2; shift; shift ;;
    --fonts-enum) FONTS_ENUM=$2; shift; shift ;;

	--info-plist) INFO_PLIST=$2; shift; shift ;;

    --nibs-dir) NIBS_DIR=$2; shift; shift ;;
    --nibs-src) NIBS_SRC=$2; shift; shift ;;
    --nibs-import) NIBS_IMPORT=$2; shift; shift ;;

    --xcassets) XCASSETS=$2; shift; shift ;;
    --colors-src) COLORS_SRC=$2; shift; shift ;;
    * ) break ;;
  esac
done

DIR=`dirname "$0"`

if [ -n "$STRINGS_SRC" ]; then
	"$DIR/genswiftstrings.swift" "$STRINGS" "$STRINGS_SRC" "$STRINGS_DICT" "$STRINGS_ENUM" $STRINGS_TABLE
fi

if [ -n "$STORYBOARDS_SRC" ]; then
	find "$STORYBOARDS_DIR" -type f -iname "*.storyboard" -print0 | xargs -0 "$DIR/genswiftstoryboards.swift"  "$STORYBOARDS_SRC" "$STORYBOARDS_IMPORT"
fi

if [ -n "$FONTS_SRC" ]; then
	"$DIR/genswiftfonts.swift" "$FONTS_SRC" "$FONTS_ENUM" "$FONTS_DIR" "$INFO_PLIST"
fi

if [ -n "$NIBS_SRC" ]; then
	find "$NIBS_DIR" -type f -iname "*.xib" -print0 | xargs -0 "$DIR/genswiftnibs.swift" "$NIBS_SRC" "$NIBS_IMPORT"
fi

if [ -n "$COLORS_SRC" ]; then
	find "$XCASSETS" -type d -iname "*.colorset" -print0 | xargs -0 "$DIR/genswiftcolors.swift" "$COLORS_SRC"
fi

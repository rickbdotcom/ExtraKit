#!/bin/bash

if ! [ -x "$(command -v marathon)" ]; then
  echo 'warning: install marathon to autogenerate updated sources'
  exit 0
fi

SCRIPT_ROOT="${PODS_ROOT}/ExtraKit/scripts"

marathon run "${SCRIPT_ROOT}/genswiftcolors" --xcassets "Fleet SmartHub/Assets.xcassets" --src "Fleet SmartHub/Colors.swift"
marathon run "${SCRIPT_ROOT}/genswiftnibs" --nibs "Fleet SmartHub/UI/Base.lproj" --src "Fleet SmartHub/Nibs.swift"

#"${GENSWIFT}" --storyboards-dir "Fleet SmartHub/UI/Base.lproj" --storyboards-src "Fleet SmartHub/Storyboards.swift" --storyboards-import none

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

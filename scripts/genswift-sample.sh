#!/bin/bash

if ! [ -x "$(command -v marathon)" ]; then
  echo 'warning: install marathon to autogenerate updated sources'
  exit 0
fi

PODS_ROOT="/Users/rickb/Developer/rickb/"
SCRIPT_ROOT="${PODS_ROOT}/ExtraKit/scripts"
RUN="marathon run"

${RUN} "${SCRIPT_ROOT}/genswiftcolors" --xcassets "Fleet SmartHub/Assets.xcassets" --src "Fleet SmartHub/Colors.swift"
${RUN} "${SCRIPT_ROOT}/genswiftnibs" --nibs "Fleet SmartHub/UI/Base.lproj" --src "Fleet SmartHub/Nibs.swift"
${RUN} "${SCRIPT_ROOT}/genswiftstoryboards" --storyboards "Fleet SmartHub/UI/Base.lproj" --src "Fleet SmartHub/Storyboards.swift"

while true; do
  case "$1" in
    --strings ) STRINGS=$2; shift; shift ;;
    --stringsdict ) STRINGS_DICT=$2; shift; shift ;;
    --strings-src ) STRINGS_SRC=$2; shift; shift ;;
    --strings-enum ) STRINGS_ENUM=$2; shift; shift ;;
    --strings-table ) STRINGS_TABLE=$2; shift; shift ;;

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

if [ -n "$FONTS_SRC" ]; then
	"$DIR/genswiftfonts.swift" "$FONTS_SRC" "$FONTS_ENUM" "$FONTS_DIR" "$INFO_PLIST"
fi

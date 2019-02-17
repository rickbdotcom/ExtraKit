#!/bin/bash

# add to build phase before compile sources, modify as needed to your environment
if ! [ -x "$(command -v marathon)" ]; then
  echo 'warning: install marathon to autogenerate updated sources'
  exit 0
fi

SCRIPT_ROOT="../scripts" # "${PODS_ROOT}/ExtraKit/scripts" # <- should be this in real app
SRC="Example" # set to your path or customize paths below
RUN="marathon run"

${RUN} "${SCRIPT_ROOT}/genswiftcolors" --in "${SRC}/Assets.xcassets" --out "${SRC}/Colors.swift"
${RUN} "${SCRIPT_ROOT}/genswiftnibs" --in "${SRC}/Base.lproj" --out "${SRC}/Nibs.swift"
${RUN} "${SCRIPT_ROOT}/genswiftstoryboards" --in "${SRC}/Base.lproj" --out "${SRC}/Storyboards.swift"
${RUN} "${SCRIPT_ROOT}/genswiftfonts" --in "${SRC}/Fonts" --out "${SRC}/Fonts.swift"
${RUN} "${SCRIPT_ROOT}/genswiftstrings" --in "${SRC}/en.lproj/Localizable.strings" --out "${SRC}/Strings.swift"
${RUN} "${SCRIPT_ROOT}/genswiftstrings" --in "${SRC}/en.lproj/Localizable.stringsdict" --out "${SRC}/StringsDict.swift"

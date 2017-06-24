#!/bin/bash
REV=`git log --pretty='oneline' | wc -l | sed 's/\ //g'`
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $REV" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
SHA=`git rev-parse HEAD`
/usr/libexec/PlistBuddy -c "Set :git-sha1 $SHA" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

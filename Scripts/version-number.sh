#!/bin/sh

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -p|--push)
    PUSH_CHANGE="$2"
    shift # past argument
    ;;
    -ma|--major)
    MAJOR_INCREMENT=true
    shift # past argument
    ;;
    -mi|--minor)
    MINOR_INCREMENT=true
    shift # past argument
    ;;
    -r|--revision)
    REVISION_INCREMENT=true
    shift # past argument
    ;;
    -v|--version)
    CUSTOM_INCREMENT="$2"
    shift
    shift
    ;;
esac
done

BRANCH=$(git rev-parse --abbrev-ref HEAD)
PLIST_PATH="../CMPComapiFoundation/Info.plist"
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$PLIST_PATH")

echo "Current version is $VERSION"

if [ ! -z "$CUSTOM_INCREMENT" ]; then
    VERSION=$CUSTOM_INCREMENT

    echo "Changing version to specified $VERSION"  
fi

if [ ! -z "$MAJOR_INCREMENT" ]; then
    MAJOR=${VERSION:0:1}
    MAJOR=$((MAJOR+1))
    VERSION="${MAJOR}.0.0"

    echo "Incremented major number, current version is $VERSION"
fi

if [ ! -z "$MINOR_INCREMENT" ]; then
    MINOR=${VERSION:2:1}
    MINOR=$((MINOR+1))
    VERSION="${VERSION:0:2}${MINOR}${VERSION:3}"

    echo "Incremented minor number, current version is $VERSION"
fi

if [ ! -z "$REVISION_INCREMENT" ]; then
    REVISION=${VERSION:4:1}
    REVISION=$((REVISION+1))
    VERSION="${VERSION:0:4}${REVISION}${VERSION:5}"

    echo "Incremented revision number, current version is $VERSION"
fi

cd .. ; xcrun agvtool new-marketing-version $VERSION

sed -i '' "s/CMPSDKInfo const CMPSDKInfoVersion = \@\".*\";/CMPSDKInfo const CMPSDKInfoVersion = \@\"${VERSION}\";/" Sources/Core/Constants/CMPConstants.m
sed -E -i '' "s/s.version[ \t]*=[ \t]*'.*'/s.version = '${VERSION}'/" CMPComapiFoundation.podspec

if [ ! -z "$PUSH_CHANGE" ]; then
    git commit -m "bump version to $VERSION"
    git push origin $PUSH_CHANGE
fi
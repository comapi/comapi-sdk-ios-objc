#!/bin/sh

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -p|--push)
    PUSH_CHANGE=true
    shift # past argument
    ;;
    -b|--branch)
    BRANCH="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

if [ -z "$BRANCH" ]; then 
    BRANCH="dev"
fi

if [ -z "$PUSH_CHANGE" ]; then 
    PUSH_CHANGE=false
fi

BUILD_NUMBER=$(expr $(git rev-list $BRANCH --count) - $(git rev-list HEAD..$BRANCH --count))

cd .. ; xcrun agvtool new-version $BUILD_NUMBER

if [ "$PUSH_CHANGE" = true ]; then
    git commit -m "bump build number to $BUILD_NUMBER"
    git push origin $branch
fi
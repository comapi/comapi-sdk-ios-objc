#!/bin/sh

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -a|--app)
    APP="$2"
    shift # past argument
    shift
    ;;
esac
done

DIR="$HOME/Desktop/dotdigital/Builds"
SWIFT_DIR="$DIR/Swift"
OBJC_DIR="$DIR/Objective-C"

cd ..

xcrun agvtool next-version -all

if [ "$APP" = "swift" ] || [ "$APP" = "s" ]; then
    xcodebuild archive -workspace CMPComapiFoundation.xcworkspace -scheme ComapiFoundationSample-Swift -archivePath $SWIFT_DIR/ComapiFoundationSample-Swift.xcarchive
    xcodebuild -exportArchive -archivePath $SWIFT_DIR/ComapiFoundationSample-Swift.xcarchive -exportOptionsPlist ComapiFoundationSample-Swift/SampleSwiftExportOptions.plist -exportPath $SWIFT_DIR
    
    echo "Exported .ipa bundle to $SWIFT_DIR"
fi

if [ "$APP" = "objc" ] || [ "$APP" = "o" ] || [ "$APP" = "" ]; then
    xcodebuild archive -workspace CMPComapiFoundation.xcworkspace -scheme ComapiFoundationSample -archivePath $OBJC_DIR/ComapiFoundationSample.xcarchive
    xcodebuild -exportArchive -archivePath $OBJC_DIR/ComapiFoundationSample.xcarchive -exportOptionsPlist ComapiFoundationSample/SampleExportOptions.plist -exportPath $OBJC_DIR
    
    echo "Exported .ipa bundle to $OBJC_DIR"
fi



#!/bin/sh

xcodebuild clean analyze -workspace CMPComapiFoundation.xcworkspace -scheme CMPComapiFoundation
xcodebuild build -workspace CMPComapiFoundation.xcworkspace -scheme CMPComapiFoundation
xcodebuild test -workspace CMPComapiFoundation.xcworkspace -scheme CMPComapiFoundationTests -destination 'platform=iOS Simulator,name=iPhone SE'
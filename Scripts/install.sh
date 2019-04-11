#!/bin/sh

pod cache clean --all
pod deintegrate ../CMPComapiFoundation.xcodeproj
pod install
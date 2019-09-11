#!/bin/sh

cd ..

pod cache clean --all
pod deintegrate 
pod install --clean-install
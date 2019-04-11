#!/bin/sh

APP=$1

bash install.sh
bash build-test.sh
bash archive-export.sh $APP




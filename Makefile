#  Makefile
#  <-dock->
#
#  Created by John Smith on 5/5/15.
#  Copyright (c) 2015 ohnnyj. All rights reserved.

.PHONY: clean build

default: clean build

clean:
	xcrun xcodebuild -scheme "<-dock-swift->" -configuration Release clean

build:
	xcrun xcodebuild -scheme "<-dock-swift->" -configuration Release build
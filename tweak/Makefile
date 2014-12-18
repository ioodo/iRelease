
export ADDITIONAL_CFLAGS += -I../include -I../include/SpringBoard -I../include/FrontBoard -I../src

TWEAK_NAME = Release
Release_FILES = \
	../src/ReleaseSetting.m \
	SpringBoardHooks.xm \
	UIStatusBarHooks.xm \
	main.mm

Release_FRAMEWORKS = \
		UIKit \
		QuartzCore \
		Foundation \
		CoreGraphics

export THEOS_PATH=/opt/theos/
include ${THEOS_PATH}/makefiles/common.mk
include ${THEOS_PATH}/makefiles/tweak.mk

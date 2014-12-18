
export SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.1.sdk

export TARGET=iphone:clang::8.0
export ARCHS = armv7 armv7s arm64

THEOS_DEVICE_IP = 192.168.1.101
SUBPROJECTS = tweak ReleasePreferences

export ADDITIONAL_LDFLAGS += -lsqlite3 -lMobileGestalt

export THEOS_PATH=/opt/theos/
include ${THEOS_PATH}/makefiles/common.mk
include ${THEOS_PATH}/makefiles/aggregate.mk

after-stage::
	rm -rf ./com.ioodo.*

after-install::
	install.exec "killall -9 SpringBoard"

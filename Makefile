export THEOS_DEVICE_IP=10.0.0.171 THEOS_DEVICE_PORT=22
export ARCHS = armv7 arm64
export TARGET := iphone:clang:14.5:7.0

INSTALL_TARGET_PROCESSES = KillerClownCall


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppLock

AppLock_FILES = Tweak.x ButtonClass.m
APPLock_FRAMEWORKS = UIKit
AppLock_EXTRA_FRAMEWORKS = AltList
AppLock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

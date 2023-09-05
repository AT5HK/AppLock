export THEOS_DEVICE_IP=10.0.0.171 THEOS_DEVICE_PORT=22
export ARCHS = arm64
export TARGET := iphone:clang:16.4:7.0

INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppLock

AppLock_FILES = Tweak.x ButtonClass.m
APPLock_FRAMEWORKS = UIKit MobileCoreServices
AppLock_PRIVATE_FRAMEWORKS = Preferences MobileCoreServices UIKitCore #SpringBoard "adding springboard framework
# stops symbols error but the entire tweak stops working even SBPowerDownController

AppLock_EXTRA_FRAMEWORKS = AltList
AppLock_CFLAGS = -fobjc-arc -I./Frameworks/AltList.framework/Headers

AppLock_LDFLAGS = -v #-L./Frameworks/AltList.framework


include $(THEOS_MAKE_PATH)/tweak.mk

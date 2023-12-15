# export THEOS_DEVICE_IP=10.0.0.171 THEOS_DEVICE_PORT=22
export THEOS_DEVICE_IP=127.0.0.1 
export THEOS_DEVICE_PORT=2222

export ARCHS = arm64 #armv7 arm64e
export TARGET := iphone:clang:16.4:7.0

#both rootless and rootful causes errors. leave blank 
#but on iphone 8 ios 15 i have to set THEOS_PACKAGE_SCHEME = rootless or i get error
# THEOS_PACKAGE_SCHEME = rootlful
THEOS_PACKAGE_SCHEME = rootless

# INSTALL_TARGET_PROCESSES = SpringBoard
INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppLock

AppLock_FILES = Tweak.x ButtonClass.m PasswordManager.m 
APPLock_FRAMEWORKS = UIKit LocalAuthentication 
AppLock_PRIVATE_FRAMEWORKS = Preferences MobileCoreServices #UIKitCore #SpringBoard "adding springboard framework
# stops symbols error but the entire tweak stops working even SBPowerDownController

AppLock_EXTRA_FRAMEWORKS = AltList
AppLock_CFLAGS = -v -fobjc-arc #-I./Frameworks/AltList.framework/Headers

AppLock_LDFLAGS = #-L./Frameworks/AltList.framework


include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

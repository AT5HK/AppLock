# TARGET := iphone:clang:latest:7.0
TARGET := iphone:clang:16.4:15.0


include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Prefs

Prefs_FILES = APLRootListController.m
Prefs_FRAMEWORKS = UIKit
Prefs_PRIVATE_FRAMEWORKS = Preferences 
Prefs_EXTRA_FRAMEWORKS = AltList
Prefs_INSTALL_PATH = /Library/PreferenceBundles
Prefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk


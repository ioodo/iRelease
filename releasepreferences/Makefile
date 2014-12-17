include theos/makefiles/common.mk

BUNDLE_NAME = ReleasePreferences
ReleasePreferences_FILES = ReleasePreferences.mm
ReleasePreferences_INSTALL_PATH = /Library/PreferenceBundles
ReleasePreferences_FRAMEWORKS = UIKit
ReleasePreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ReleasePreferences.plist$(ECHO_END)

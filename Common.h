#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define USER_DEFAULTS_DOMAIN @"com.applock.prefs.isTweakOn"

#define TWEAK_SPECIFIER_KEY @"isTweakEnabled"
#define BIOMETRICS_SPECIFIER_KEY @"isBiometricsEnabled"
#define PASSCODE_SPECIFIER_KEY @"isPasscodeEnabled"

#define SCREEN_WIDTH [ [ UIScreen mainScreen ] bounds ].size.width
#define SCREEN_HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height

#define PASSWORD_STRING_MAX_LENGTH 50
#define PASSWORD_STRING_MIN_LENGTH 0
#define USER_DEFAULTS_DOMAIN_PASSCODE @"com.applock.prefs.passcode"
#define BUNDLE_DEFAULTS_PASSCODE_KEY @"passcode"

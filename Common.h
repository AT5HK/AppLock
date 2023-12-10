#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define USER_DEFAULTS_DOMAIN @"com.applock.prefs.isTweakOn"

#define TWEAK_SPECIFIER_KEY @"isTweakEnabled"
#define BIOMETRICS_SPECIFIER_KEY @"isBiometricsEnabled"
#define PASSCODE_SPECIFIER_KEY @"isPasscodeEnabled"
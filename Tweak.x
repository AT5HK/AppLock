#import "Tweak.h"

static PasswordManager *passwordManager;

//bundle IDs of switches enabled to lock apps
NSArray* updateEnabledBundleIDs() {
   NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN_IS_ENABLED];
   NSArray *enabledBundleIDs = bundleDefaults[BUNDLE_DEFAULTS_IS_ENABLED_KEY];
   NSLog(@"the enabled bundle ids: %@", enabledBundleIDs);
   return enabledBundleIDs;
}

BOOL isAppLockEnabled() {
   NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
   NSNumber *isEnabled = bundleDefaults[TWEAK_SPECIFIER_KEY];
   return [isEnabled boolValue];
}

static void appLockSetup() {
   passwordManager = [PasswordManager sharedInstance];
}

%hook APUIAppIconGridView
   -(void)iconTapped:(SBIconView *)iconView {
      //check if AppLock tweak is enabled, if not run original method and exit hooked method
      if (isAppLockEnabled() == false) { %orig; return; } 
      
      
      NSString *bundleID = iconView.applicationBundleIdentifierForShortcuts;
      NSLog(@"the bundleID: %@", bundleID);
      NSArray *lockedBundleIDs = updateEnabledBundleIDs();
      BOOL isApplicationLocked = [lockedBundleIDs containsObject:bundleID];

      // //check if app has been locked, if not run original method and exit hooked method
      if (isApplicationLocked == false) { %orig; return; }

      [passwordManager authenticate:^(BOOL isAuthenticated, NSError *authenticationError) {
         if (isAuthenticated == true) {
            NSLog(@"passwordManager authenticate works");
            %orig;
         } else {
            //do nothing, don't open the app
         }
      }];
   }

%end

%hook SearchUIHomeScreenAppIconView

- (void)icon:(SBHApplicationIcon*)applicationIcon launchFromLocation:(id)arg2 context:(id)arg3 {
   //check if AppLock tweak is enabled, if not run original method and exit hooked method
   if (isAppLockEnabled() == false) { %orig; return; } 
   
   
   NSString *bundleID = applicationIcon.applicationBundleID;
   NSLog(@"the bundleID: %@", bundleID);
   NSArray *lockedBundleIDs = updateEnabledBundleIDs();
   BOOL isApplicationLocked = [lockedBundleIDs containsObject:bundleID];

   // //check if app has been locked, if not run original method and exit hooked method
   if (isApplicationLocked == false) { %orig; return; }

   [passwordManager authenticate:^(BOOL isAuthenticated, NSError *authenticationError) {
      if (isAuthenticated == true) {
         NSLog(@"passwordManager authenticate works");
         %orig;
      } else {
         //do nothing, don't open the app
      }
   }];
}

%end

%hook SBUIController

-(void)activateApplication:(SBApplication *)application fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
   
   //check if AppLock tweak is enabled, if not run original method and exit hooked method
   if (isAppLockEnabled() == false) { %orig; return; } 
   
   
   NSString *bundleID = application.bundleIdentifier;
   NSLog(@"the bundleID: %@", bundleID);
   NSArray *lockedBundleIDs = updateEnabledBundleIDs();
   BOOL isApplicationLocked = [lockedBundleIDs containsObject:bundleID];

   //check if app has been locked, if not run original method and exit hooked method
   if (isApplicationLocked == false) { %orig; return; }

   [passwordManager authenticate:^(BOOL isAuthenticated, NSError *authenticationError) {
      if (isAuthenticated == true) {
         NSLog(@"passwordManager authenticate works");
         %orig;
      } else {
         //do nothing, don't open the app
      }
   }];
   
}

%end


 %ctor {
   appLockSetup();
 }




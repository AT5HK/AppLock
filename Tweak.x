#import "Tweak.h"
// #import "dlfcn.h"
// #import "SpringBoard.h"

static PasswordManager *passwordManager;


NSArray* updateEnabledBundleIDs() {
   NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.prefs"];
   NSArray *enabledBundleIDs = bundleDefaults[@"isEnabled"];
   NSLog(@"the enabled bundle ids: %@", enabledBundleIDs);
   // NSLog(@"enabled apps: %@", [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.prefs"][@"isEnabled"]);
   return enabledBundleIDs;
}

BOOL isAppLockEnabled() {
   NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.prefs.isTweakOn"];
   NSNumber *isEnabled = bundleDefaults[@"isTweakEnabled"];
   return [isEnabled boolValue];
}

static void appLockSetup() {
   passwordManager = [PasswordManager sharedInstance];
}

%hook APUIAppIconGridView
   -(void)iconTapped:(id)arg1 {
      if (isAppLockEnabled() == false) { %orig; return; } //run the original method and exit hooked method before
      %log(@"iconTapped: %@", arg1);
      

      %orig;
   }

   // -(id)bundleIdAtLocation:(CGPoint)arg1 {
   //    %log(@"bundleIdAtLocation: %@", NSStringFromCGPoint(arg1));
   //    return %orig;
   // }

   // -(BOOL)appIconDataSource:(id)arg1 launchAppFromIcon:(id)arg2 {
   //    return %orig;
   // }

%end

// %hook SBIcon
// -(void)launchFromLocation:(id)arg1 context:(id)arg2 {
//    NSLog(@"launchFromLocation: %@", arg1);
//    %log;
//    %orig;
// }

// %end

// %hook SpringBoard
// - (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(_Bool)arg2 {
//    %log(@"called launchApplicationWithIdentifier: %@", arg1);
//    return %orig;
// }
// %end

// %hook SBUserAgent
// -(BOOL)canLaunchFromSource:(int)arg1 withURL:(id)arg2 bundleID:(id)arg3 {
//    %log(@"called canLaunchFromSource: %@", arg3);
//    return %orig;
// }
// %end

// %hook SBStarkIconController
// - (BOOL)icon:(id)arg1 launchFromLocation:(long long)arg2 context:(id)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
//    %log(@"called canLaunchFromSource: %@", arg3);
//    return %orig;
// }
// %end

%hook SearchUIHomeScreenAppIconView
// - (void)iconTapped:(id)arg1 {
//    %log(@"iconTapped");
// }

// -(void)launchIcon {
//    %log;
// }

- (void)icon:(id)arg1 launchFromLocation:(id)arg2 context:(id)arg3 {
   BOOL tweakEnabled = isAppLockEnabled();
   NSLog(@"is applocked enabled: %d", tweakEnabled);
   if (tweakEnabled == false) {
      %orig;
      return;
   }
   [passwordManager checkForPassword:@"password" withCompletion:^(BOOL isPasswordCorrect) {
      if (isPasswordCorrect == true) {
         %orig;
      } else {
         //do nothing, don't open the app
      }
   }];
}

%end



// %hook SBMainWorkspace
// // -(void)applicationProcessWillLaunch:(id)arg1 {
// //    %log;
// //    %orig;
// // }

// -(id)createRequestForApplicationActivation:(id)arg1 options:(unsigned long long)arg2 {
//    //laContext to authenticate via touch id also calls this method
//    // and it seems semaphore needed to wait for the block and then return the orginal function is causing the function
//    //to stall, it is not called a second time.

//    SBDeviceApplicationSceneEntity *sceneEntity = (SBDeviceApplicationSceneEntity*)arg1;
//    NSString *bundleIdentifier = [sceneEntity valueForKey:@"_identifier"];
//    NSLog(@"the bundleIdentifier: %@", bundleIdentifier);
//    // NSLog(@"the sceneEntity.uniqueIdentifier: %@", sceneEntity.uniqueIdentifier);
   

   
     
//     %log(@"called: createRequestForApplicationActivation");
//     return %orig;
// }

// -(void)systemService:(id)arg1 handleOpenApplicationRequest:(id)arg2 withCompletion:(/*^block*/id)arg3 {
//    %log;
//    %orig;
// }

// -(void)systemService:(id)arg1 canActivateApplication:(id)arg2 withResult:(/*^block*/id)arg3 {
//    %log;
//    %orig;
// }

// %end

// %hook FBProcess 
// -(void)_launchDidComplete:(BOOL)arg1 finalizeBlock:(/*^block*/id)arg2 {
//    %log(@"_launchDidComplete");
// }
// %end

// %hook FBProcessManager

// - (void)applicationProcessWillLaunch:(id)arg1 {
//    %log(@"applicationProcessWillLaunch");
// }
// -(id)createApplicationProcessForBundleID:(id)arg1 {
//    %log(@"createApplicationProcessForBundleID");
//    return %orig;
// }

// // iOS >= 15
// - (id)_bootstrapProcessWithExecutionContext:(id)executionContext synchronously:(BOOL)synchronously error:(id *)error
// {

//    %log(@"wtf the damn process");
//    NSLog(@"wtf the damn process");
// 	return %orig;
// }


// -(void)sceneDidActivate:(id)arg0 {
//    NSLog(@"called sceneDidActivate: %@",arg0);
// }

// -(void)systemService:(id)arg0 canActivateApplication:(id)arg1 withResult:(id)arg2 {
//    NSLog(@"canActivateApplication");
// }

// // // iOS 13 - 14
// // - (id)_createProcessWithExecutionContext:(FBProcessExecutionContext *)executionContext
// // {
// //    %log(@"wtf the damn process");
// //    NSLog(@"wtf the damn process");
// // 	return %orig;
// // }

// // // iOS <= 12
// // - (id)createApplicationProcessForBundleID:(NSString *)bundleIdentifier withExecutionContext:(FBProcessExecutionContext *)executionContext
// // {

  
// //    %log(@"wtf the damn process");
// //    NSLog(@"wtf the damn process");
// //    return %orig;

// // }


// %end

// %hook SBIconView
// -(BOOL)gestureRecognizerShouldBegin:(id)arg1 {
//    return false;
// }
// %end

// %hook SBIconImageView

// -(BOOL)setHidden:(BOOL)arg1 {
//    return true;
// }

// %end



// %hook SBApplicationController

   // - (id)runningApplications {
   //    id runningApps = %orig;
   //    NSLog(@"the running apps: %@", runningApps);
   //    return runningApps;
   // }


   // -(BOOL)scheduler:(id)arg1 requestsApplicationLaunch:(id)arg2 {
   //    NSLog(@"scheduled app");
   //    return %orig;
   // }

   // - (id)_lock_applicationWithBundleIdentifier:(id)arg1 {
   //    id lockedApp = %orig;
   //    NSLog(@"succesfully locked application: %@", lockedApp);
   //    return lockedApp;
   // }

   // - (BOOL)scheduler:(id)arg1 requestsApplicationLaunch:(id)arg2 {
      
   // }

// %end

// SBApplicationController *appController;

// %hook FBSceneObserver
// -(void)sceneDidActivate:(id)arg0 {
//    NSLog(@"called sceneDidActivate: %@",arg0);
// }
// %end

// %hook FBSystemServiceDelegate-Protocol
// -(void)systemService:(id)arg0 canActivateApplication:(id)arg1 withResult:(id)arg2 {
//    NSLog(@"canActivateApplication");
// }
// %end



%hook SBApplication

// -(BOOL)iconAllowsLaunch:(id)arg1 {
//    NSLog(@"iconAllowsLaunch: %@", arg1);
//    return %orig;
// }

// -(void)_processWillLaunch:(id)arg1 {
//       NSLog(@"_processWillLaunch: %@", arg1);

// }


// -(void)_processDidLaunch:(id)arg1 {
//    NSLog(@"process did launch arg1: %@", arg1);
//    %orig;
// }


%end

%hook SBHomeScreenViewController

-(void)viewDidLoad {
   %log(@"called from SBHomeScreenViewController viewdidload");

   // [[NSNotificationCenter defaultCenter] 
   //                                     addObserver:self 
   //                                     selector:@selector(updateEnabledBundleIDs) 
   //                                     name:NSUserDefaultsDidChangeNotification 
   //                                     object:nil];

   ButtonClass *buttonClass = [[ButtonClass alloc]init];
   UIButton *greenButton = [buttonClass createButton];
   [greenButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:greenButton];
   // appController = [%c(SBApplicationController) sharedInstance];
   self.view.backgroundColor = UIColor.redColor;
}

%new
-(void)showAlertControllerPasswordChecker:(void(^)(NSString *alertViewText))completion {
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                               message:@"This is an alert."
                               preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
      handler:^(UIAlertAction * action) 
      {
         UITextField *alertViewTextField = alert.textFields[0];
         completion(alertViewTextField.text);
      }];
   
   
   [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = true;
    }];

   [alert addAction:defaultAction];
   [self presentViewController:alert animated:YES completion:nil];
}

%new
-(void)buttonAction {
   NSLog(@"yellow button action");
   NSLog(@"test log");
   // [[objc_getClass("SpringBoard") sharedInstance] _simulateHomeButtonPress];
   // [UIApplication.sharedApplication launchApplicationWithIdentifier:@"com.asolo.Jailbreak-Detection" suspended:false];
   // updateEnabledBundleIDs(); 
   NSLog(@"is tweak enabled: %@", isAppLockEnabled() ? @"yes" : @"no");
}

%end

%hook SBUIController

-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
   BOOL tweakEnabled = isAppLockEnabled();
   NSLog(@"is applocked enabled: %d", tweakEnabled);
   if (tweakEnabled == false) {
      %orig;
      return;
   }
   
   NSArray *enabledBundleIDs = updateEnabledBundleIDs();

   // NSLog(@"what is arg1: %@, arg2: %@, arg3: %lld, arg4: %@, arg5: %@", arg1, arg2, arg3, arg4, arg5);
   SBApplication *SBApp = arg1;
   NSString *bundleID = SBApp.bundleIdentifier;
   NSLog(@"the bundleID: %@", bundleID);
if ([enabledBundleIDs containsObject:bundleID] == true) {
   [passwordManager checkForPassword:@"password" withCompletion:^(BOOL isPasswordCorrect) {
      if (isPasswordCorrect == true) {
         %orig;
      } else {
         //do nothing, don't open the app
      }
   }];
} else {
   %orig;
}

// if ([bundleID isEqual:@"com.asolo.Jailbreak-Detection"]) {
//    LAContext *laContext = [[LAContext alloc]init];

//    [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics 
//                localizedReason:@"authenticate to open app" 
//                reply:^(BOOL success, NSError * _Nullable error) {
//                   if (success) {
//                      dispatch_async(dispatch_get_main_queue(), ^{
//                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                            %orig;
//                         });
//                      });
                     
//                   } else {
//                      //touch id failed to show
//                   }
//    }];
// } else {
//    %orig;
// }

   
   
  


   /* 
   can only reference SBUIController using %c even though I can see the header file
    inside $theos/vendor/include, but i can reference SBApplication from here just fine
   */

   //sharedInstance is a class method %c allows me to get the class definition
   // SBUIController *SBVC = [%c(SBUIController) sharedInstance]; 
   // NSLog(@"%@", SBVC);
   // UIView *myView = [SBVC valueForKey:@"_contentView"];
   // [myView setBackgroundColor:[UIColor purpleColor]];

   // UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
   //  tapGesture.delegate = self;
   //  [myView addGestureRecognizer:tapGesture];
   
}


// %new
// -(void)handleSingleTap {
//    NSLog(@"its a single tap");
// }

%end




 //you can add commas to %init to init more classes
 %ctor {
   appLockSetup();

	// %init(
   //      //ViewController=objc_getClass("KillerClownCall.ViewController")
        
   //   );

   // NSArray<LSApplicationProxy*> *appProxyArray = [[LSApplicationWorkspace defaultWorkspace] allInstalledApplications];
//    NSArray<LSApplicationProxy*>* allInstalledApplications = [[LSApplicationWorkspace defaultWorkspace] atl_allInstalledApplications];
//    NSLog(@"the appProxyArray: %@",allInstalledApplications);

// //this sometimes causes the iphone to go into safe mode
//    for (LSApplicationProxy *appProxy in allInstalledApplications) {
//       NSLog(@"from appProxy array: %@", [appProxy applicationIdentifier]);
//       NSLog(@"is a user application: %@", [appProxy atl_isUserApplication] ? @"true":@"false");
//    }
 }




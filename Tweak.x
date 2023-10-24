#import "Tweak.h"
#import "dlfcn.h"
// #import "SpringBoard.h"

// %hook _WGWidgetRemoteViewController 

// %end

// %hook FBProcessManager

// // iOS >= 15
// - (id)_bootstrapProcessWithExecutionContext:(FBProcessExecutionContext *)executionContext synchronously:(BOOL)synchronously error:(id *)error
// {

//    %log(@"wtf the damn process");
//    NSLog(@"wtf the damn process");
// 	return %orig;
// }

// // iOS 13 - 14
// - (id)_createProcessWithExecutionContext:(FBProcessExecutionContext *)executionContext
// {
//    %log(@"wtf the damn process");
//    NSLog(@"wtf the damn process");
// 	return %orig;
// }

// // iOS <= 12
// - (id)createApplicationProcessForBundleID:(NSString *)bundleIdentifier withExecutionContext:(FBProcessExecutionContext *)executionContext
// {

  
//    %log(@"wtf the damn process");
//    NSLog(@"wtf the damn process");
//    return %orig;

// }


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

%hook SBHomeScreenViewController

-(void)viewDidLoad {
   %log(@"called from SBHomeScreenViewController viewdidload");

   ButtonClass *buttonClass = [[ButtonClass alloc]init];
   UIButton *greenButton = [buttonClass createButton];
   [greenButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:greenButton];
   // appController = [%c(SBApplicationController) sharedInstance];
   self.view.backgroundColor = UIColor.purpleColor;
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
   // [[objc_getClass("SpringBoard") sharedInstance] _simulateHomeButtonPress];

}

%end

%hook SBUIController

-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
   // SBHomeScreenBackdropViewBase *homeScreenBackdrop = [((SBUIController*)self) valueForKey:@"_homeScreenBackdropView"];
   // [homeScreenBackdrop setBackgroundColor:[UIColor redColor]];

   NSLog(@"what is arg1: %@, arg2: %@, arg3: %lld, arg4: %@, arg5: %@", arg1, arg2, arg3, arg4, arg5);
   SBApplication *SBApp = arg1;
   NSString *bundleID = SBApp.bundleIdentifier;
   NSLog(@"the bundleID: %@", bundleID);

   


   if ([bundleID isEqual:@"com.zhiliaoapp.musically"]) {
      SBHomeScreenWindow *homeScreenWindow = [self valueForKey:@"_window"];
      SBHomeScreenViewController *homeScreenVC = homeScreenWindow.homeScreenViewController;

      [homeScreenVC showAlertControllerPasswordChecker:^(NSString *alertViewText) {
        if ([alertViewText isEqual:@"password"]) {
            %orig;
        } else {
            //wrong password do nothing
        }
      }];
   } else {
      if ([bundleID isEqual:@"com.asolo.Jailbreak-Detection"]) {
         LAContext *laContext = [[LAContext alloc]init];

         [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics 
                     localizedReason:@"authenticate to open app" 
                     reply:^(BOOL success, NSError * _Nullable error) {
                        if (success) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                 %orig;
                              });
                           });
                           
                        } else {
                           //touch id failed to show
                        }
         }];
      } else {
         //its not killer clown call or go battle guide just open it
         %orig;
      }
   }

   
   
  


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

// %hook SBPowerDownController 

// -(void)orderFront {
//     %log(@"called the orderFront method");
//     NSLog(@"called the orderFront method");
//     UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"LockApps" message:@"YOUR_PASSWORD" delegate:nil cancelButtonTitle:@"CONTINUE" otherButtonTitles:@"CANCEL", nil];
//     alert.delegate = self;
//     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//     UITextField *alertTextField = [alert textFieldAtIndex:0];
//     alertTextField.keyboardType = UIKeyboardTypeDefault;
// //    alertTextField.secureTextEntry = YES;
//     alertTextField.placeholder = @"ENTER_PASSWORD";
//     [alert show];
// }


// %end

 //you can add commas to %init to init more classes
 %ctor {
	// %init(
   //      //ViewController=objc_getClass("KillerClownCall.ViewController")
        
   //   );

   // NSArray<LSApplicationProxy*> *appProxyArray = [[LSApplicationWorkspace defaultWorkspace] allInstalledApplications];
   NSArray<LSApplicationProxy*>* allInstalledApplications = [[LSApplicationWorkspace defaultWorkspace] atl_allInstalledApplications];
   NSLog(@"the appProxyArray: %@",allInstalledApplications);

//this sometimes causes the iphone to go into safe mode
   // for (LSApplicationProxy *appProxy in allInstalledApplications) {
   //    NSLog(@"from appProxy array: %@", [appProxy applicationIdentifier]);
   //    NSLog(@"is a user application: %@", [appProxy atl_isUserApplication] ? @"true":@"false");
   // }
 }




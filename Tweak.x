#import "Tweak.h"

%hook SBHomeScreenViewController

-(void)viewDidLoad {
   %log(@"called from SBHomeScreenViewController viewdidload");

   ButtonClass *buttonClass = [[ButtonClass alloc]init];
   UIButton *greenButton = [buttonClass createButton];
   [greenButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:greenButton];

   
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
   NSLog(@"fuck button action called");
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

   if ([bundleID isEqual:@"com.Raca.KillerClownCall"]) {
      SBHomeScreenWindow *homeScreenWindow = [self valueForKey:@"_window"];
      SBHomeScreenViewController *homeScreenVC = homeScreenWindow.homeScreenViewController;
      // [homeScreenVC buttonAction];
      [homeScreenVC showAlertControllerPasswordChecker:^(NSString *alertViewText) {
        if ([alertViewText isEqual:@"password"]) {
            %orig;
        } else {
            //wrong password do nothing
        }
      }];
   } else {
      %orig;
   }
   
  


   /* 
   can only reference SBUIController using %c even though I can see the header file
    inside $theos/vendor/include, but i can reference SBApplication from here just fine
   */

   //sharedInstance is a class method %c allows me to get the class definition
   SBUIController *SBVC = [%c(SBUIController) sharedInstance]; 
   NSLog(@"%@", SBVC);
   UIView *myView = [SBVC valueForKey:@"_contentView"];
   [myView setBackgroundColor:[UIColor purpleColor]];

   UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap)];
    tapGesture.delegate = self;
    [myView addGestureRecognizer:tapGesture];
   
}

%new
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
   NSLog(@"gesture recog");
   return true;
}

%new
-(void)handleSingleTap {
   NSLog(@"its a single tap");
}

%end

%hook SBPowerDownController 

-(void)orderFront {
    %log(@"called the orderFront method");
    NSLog(@"called the orderFront method");
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"LockApps" message:@"YOUR_PASSWORD" delegate:nil cancelButtonTitle:@"CONTINUE" otherButtonTitles:@"CANCEL", nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
//    alertTextField.secureTextEntry = YES;
    alertTextField.placeholder = @"ENTER_PASSWORD";
    [alert show];
}


%end

 //you can add commas to %init to init more classes
 %ctor {
	// %init(
   //      //ViewController=objc_getClass("KillerClownCall.ViewController")
        
   //   );

   NSArray<LSApplicationProxy*> *appProxyArray = [[LSApplicationWorkspace defaultWorkspace] allInstalledApplications];
   
   for (LSApplicationProxy *appProxy in appProxyArray) {
      NSLog(@"from appProxy array: %@", [appProxy applicationIdentifier]);
      NSLog(@"is a user application: %@", [appProxy atl_isUserApplication] ? @"true":@"false");
   }
 }




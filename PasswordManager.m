#import "PasswordManager.h" 

@implementation PasswordManager

+ (id)sharedInstance {
    static PasswordManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)authenticate:(void(^)(BOOL isAuthenticated, NSError *authenticationError))completion {
    NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);

    NSDictionary *bundleDefaultsPasscode = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN_PASSCODE];
	NSLog(@"current passcode: %@", bundleDefaultsPasscode);

    NSString *appLockPasscode = bundleDefaultsPasscode[BUNDLE_DEFAULTS_PASSCODE_KEY];


    BOOL isBiometricsEnabled = [bundleDefaults[BIOMETRICS_SPECIFIER_KEY] boolValue];
    BOOL isPasscodeEnabled = [bundleDefaults[PASSCODE_SPECIFIER_KEY] boolValue];

    if (isBiometricsEnabled == true) {
        [self checkBiometrics:^(BOOL isBiometricsCorrect, NSError *checkError) {
            if (isBiometricsCorrect == true) {
                completion(isBiometricsCorrect, checkError);
            }
        }];
    }

    if (isPasscodeEnabled == true) {
        [self checkForPassword:appLockPasscode withCompletion:^(BOOL isPasswordCorrect) {
            if (isPasswordCorrect == true) {
                completion(isPasswordCorrect, nil);
            }
        }];
    }

}

-(void)checkBiometrics:(void(^)(BOOL isBiometricsCorrect, NSError *checkError))completion {
    LAContext *laContext = [[LAContext alloc]init];
    NSError *evaluatePolicyError;

    BOOL isBiometricsAvailable = [laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&evaluatePolicyError];
    if (isBiometricsAvailable == true) {
        [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics 
                localizedReason:@"authenticate to open app" 
                reply:^(BOOL success, NSError *error) {
                completion(success, error);
        }];
    } else {
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [self showAlertControllerWithVC:rootVC];
        //don't run completion biometrics is not availalbe
        // completion(isBiometricsCorrect, nil); 
    }
}


-(void)checkForPassword:(NSString *)password withCompletion:(void(^)(BOOL isPasswordCorrect))completion {
   UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

    [self showAlertControllerPasswordCheckerWithVC:rootVC withCompletion:^(UIAlertController *alertController) {
        UITextField *textField = alertController.textFields[0];
        NSString *passwordInput = textField.text;
        if ([passwordInput isEqual:password]) {
            completion(true);
        } else {
            completion(false);
        }
    }];
    

}


-(void)showAlertControllerPasswordCheckerWithVC:(UIViewController *)VC withCompletion:(void(^)(UIAlertController *alertController))completion {
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                               message:@"This is an alert."
                               preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
      handler:^(UIAlertAction * action) 
      {
        //  UITextField *alertViewTextField = alert.textFields[0];
         completion(alert);
      }];
   
   
   [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = true;
    }];

   [alert addAction:defaultAction];
   [VC presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertControllerWithVC:(UIViewController *)VC {
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                               message:@"No biometrics detected, please enabled FaceID or TouchID in settings."
                               preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
      handler:^(UIAlertAction * action) 
      {
        
      }];
   
   

   [alert addAction:defaultAction];
   [VC presentViewController:alert animated:YES completion:nil];
}

@end
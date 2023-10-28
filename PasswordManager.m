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

// -(void)checkBiometrics withCompletion:(void(^)(BOOL isBiometricsCorrect, NSError * _Nullable error))completion {
//     LAContext *laContext = [[LAContext alloc]init];

//     [laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics 
//                 localizedReason:@"authenticate to open app" 
//                 reply:^(BOOL success, NSError * _Nullable error) {
                
//                 completion(success, error);
//     }];
// }


-(void)checkPassword:(NSString *)password withCompletion:(void(^)(BOOL isPasswordCorrect))completion {
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

@end
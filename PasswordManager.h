#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "Common.h"
#import "UIAlertController+Fast.h"

@interface PasswordManager : NSObject
-(void)checkForPassword:(NSString *)password withCompletion:(void(^)(BOOL isPasswordCorrect))completion;
-(void)checkBiometrics:(void(^)(BOOL isBiometricsCorrect, NSError *error))completion;
+ (id)sharedInstance;
-(void)authenticate:(void(^)(BOOL isAuthenticated, NSError *authenticationError))completion;

@end
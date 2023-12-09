#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "Common.h"

@interface PasswordManager : NSObject
-(void)checkForPassword:(NSString *)password withCompletion:(void(^)(BOOL isPasswordCorrect))completion;
-(void)checkBiometrics:(void(^)(BOOL isBiometricsCorrect, NSError *error))completion;
+ (id)sharedInstance;
@end
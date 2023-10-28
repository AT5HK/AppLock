#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface PasswordManager : NSObject
-(void)checkPassword:(NSString *)password withCompletion:(void(^)(BOOL isPasswordCorrect))completion;
-(void)checkBiometrics:(void(^)(BOOL isBiometricsCorrect, NSError *error))completion;
+ (id)sharedInstance;
@end
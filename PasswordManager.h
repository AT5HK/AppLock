#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface PasswordManager : NSObject
-(void)checkPassword:(NSString *)password withCompletion:(void(^)(BOOL isPasswordCorrect))completion;
// -(void)checkBiometrics withCompletion:(void(^)(BOOL isBiometricsCorrect, NSError * _Nullable error))completion;
+ (id)sharedInstance;
@end
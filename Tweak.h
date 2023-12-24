
#import <UIKit/UIKit.h>
#import <AltList/LSApplicationProxy+AltList.h>
// #import <MobileCoreServices/LSApplicationWorkspace.h> ios 12 uses MobileCoreServices
#import <MobileCoreServices/LSApplicationWorkspace.h> //ios 15 uses CoreServices in public frameworks
#import <LocalAuthentication/LocalAuthentication.h>
#import "PasswordManager.h"
#import "Common.h"

@interface SBHApplicationIcon
@property(readonly, copy, nonatomic) NSString *applicationBundleID;
@end

@interface UIApplication (private)
-(void)launchApplicationWithIdentifier:(NSString *)arg1 suspended:(BOOL)arg2;
@end

@interface SBIconView: UIView
@property(readonly, copy, nonatomic) NSString *applicationBundleIdentifierForShortcuts;
@end

@interface SBUIController : NSObject 
@end

@interface SBHomeScreenViewController: UIViewController
-(void)showAlertControllerPasswordChecker:(void(^)(NSString *alertViewText))completion;
@end

@interface SBApplication
@property (nonatomic,readonly) NSString * bundleIdentifier;
-(BOOL)icon:(id)arg1 launchFromLocation:(id)arg2 context:(id)arg3 ;
@end

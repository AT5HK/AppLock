
#import <UIKit/UIKit.h>
#import "ButtonClass.h"
// #import <AltList/AltList.h>
#import <AltList/LSApplicationProxy+AltList.h>
// #import <MobileCoreServices/LSApplicationWorkspace.h> ios 12 uses MobileCoreServices
#import <MobileCoreServices/LSApplicationWorkspace.h> //ios 15 uses CoreServices in public frameworks
#import <LocalAuthentication/LocalAuthentication.h>
#import "PasswordManager.h"


@interface SBDeviceApplicationSceneEntity : NSObject
@property (nonatomic,copy,readonly) NSString * uniqueIdentifier; 
@end

@interface SearchUIResultsCollectionViewController: UICollectionViewController

@end

@interface UIApplication (private)
-(void)launchApplicationWithIdentifier:(NSString *)arg1 suspended:(BOOL)arg2;
@end

@interface SBIconView: UIView
-(BOOL)gestureRecognizerShouldBegin:(id)arg1;
@end

@interface SpringBoard
+ (id)sharedInstance;
- (void)_simulateHomeButtonPress;
@end


@interface SBIconImageView: UIView 

@end

@interface SBApplicationController : NSObject
- (id)_lock_applicationWithBundleIdentifier:(id)arg1;
- (id)allApplications;
-(BOOL)scheduler:(id)arg1 requestsApplicationLaunch:(id)arg2;
@end

@interface SBHomeScreenBackdropViewBase: UIView
@end

@interface SBPowerDownController

@end

@interface SBUIController : NSObject <UIGestureRecognizerDelegate> {
   SBHomeScreenBackdropViewBase* _homeScreenBackdropView;
   UIView* _contentView;
   // SBHomeScreenWindow* _window; //shows up in limenos class dump but not in theos/vendor/includes
   //have to dump Springboard.framework myself for ios 12 and see if the headers contain it 
}
- (id)valueForKey:(NSString *)arg1;
+(id)sharedInstanceIfExists;
+(id)sharedInstance;
-(BOOL)handleHomeButtonDoublePressDown;
@end

@interface SBHomeScreenViewController: UIViewController
-(void)showAlertControllerPasswordChecker:(void(^)(NSString *alertViewText))completion;
@end

@interface SBApplication
@property (nonatomic,readonly) NSString * bundleIdentifier;
-(BOOL)icon:(id)arg1 launchFromLocation:(id)arg2 context:(id)arg3 ;
@end

@interface SBWindow
@end

@interface SBHomeScreenWindow : SBWindow
@property (nonatomic,readonly) SBHomeScreenViewController * homeScreenViewController;
@end
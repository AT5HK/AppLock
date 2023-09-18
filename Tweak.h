
#import <UIKit/UIKit.h>
#import "ButtonClass.h"
// #import <AltList/AltList.h>
#import <AltList/LSApplicationProxy+AltList.h>
#import "Tweak.h"

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
@end

@interface SBWindow
@end

@interface SBHomeScreenWindow : SBWindow
@property (nonatomic,readonly) SBHomeScreenViewController * homeScreenViewController;
@end
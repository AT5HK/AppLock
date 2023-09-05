
#import <UIKit/UIKit.h>
#import "ButtonClass.h"
// #import <AltList/AltList.h>
#import <AltList/LSApplicationProxy+AltList.h>


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
@end

@interface SBHomeScreenViewController: UIViewController
@end

// @interface SBHomeScreenWindow : SBWindow
// @property (nonatomic,readonly) SBHomeScreenViewController * homeScreenViewController;
// @end

%hook SBHomeScreenViewController

-(void)viewDidLoad {
   %log(@"called from SBHomeScreenViewController viewdidload");

   ButtonClass *buttonClass = [[ButtonClass alloc]init];
   UIButton *greenButton = [buttonClass createButton];
   [greenButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:greenButton];

   
}

%new
-(void)buttonAction {
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                               message:@"This is an alert."
                               preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
      handler:^(UIAlertAction * action) {}];
   
   [alert addAction:defaultAction];
   [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = true;
    }];
   [self presentViewController:alert animated:YES completion:nil];
}

%end

%hook SBUIController

-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5 {
   // SBHomeScreenBackdropViewBase *homeScreenBackdrop = [((SBUIController*)self) valueForKey:@"_homeScreenBackdropView"];

   // SBHomeScreenWindow *homeScreenWindow = [self valueForKey:@"_window"];
   // SBHomeScreenViewController *homeScreenVC = homeScreenWindow.homeScreenViewController;
   // [homeScreenVC buttonAction];
   NSLog(@"what is arg1: %@, arg2: %@, arg3: %lld, arg4: %@, arg5: %@", arg1, arg2, arg3, arg4, arg5);
   // [homeScreenBackdrop setBackgroundColor:[UIColor redColor]];


   // UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
   //                             message:@"This is an alert."
   //                             preferredStyle:UIAlertControllerStyleAlert];
 
   // UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
   //    handler:^(UIAlertAction * action) {}];
   
   // [alert addAction:defaultAction];
   // [self presentViewController:alert animated:YES completion:nil];

   


   // SBUIController *SBVC = [SBUIController sharedInstance];
   // NSLog(@"%@", SBVC);
   // UIView *myView = [SBVC valueForKey:@"_contentView"];
   // [myView setBackgroundColor:[UIColor blackColor]];
   
   %orig;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
   BOOL shouldBegin = %orig; 
   NSLog(@"gesture recog: %d", shouldBegin);
   %log(@"gesture recognizer should begin: ", (BOOL)shouldBegin);
   return shouldBegin;
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


// %hook ViewController

//  -(void)viewDidLoad {

//     ((ViewController*)self).view.backgroundColor = [UIColor blueColor];
//     %log((NSString *)@"is the view loaded yet", (BOOL)[self isViewLoaded]);

//     %log((NSString *)@"iOSRE", (int)123);
// 	%orig;

//     ButtonClass *buttonClass = [[ButtonClass alloc]init];
//     UIButton *greenButton = [buttonClass createButton];
//     [greenButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//     [((ViewController*)self).view addSubview:greenButton];
//  }

//  %new
//  - (void)buttonAction {
//     NSLog(@"button action called");
    
//     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
//                                message:@"This is an alert."
//                                preferredStyle:UIAlertControllerStyleAlert];
 
// UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//    handler:^(UIAlertAction * action) {}];
 
// [alert addAction:defaultAction];
// [((ViewController*)self) presentViewController:alert animated:YES completion:nil];
//  }

// %end

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




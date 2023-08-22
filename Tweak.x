
#import <UIKit/UIKit.h>
#import "ButtonClass.h"



@interface ViewController: UIViewController

//@property (nonatomic,readonly) UIView *view;
@property(nonatomic, readonly, getter=isViewLoaded) BOOL viewLoaded;

-(void)callKillerClown:(id)sender;
-(void)rewardUserToken;
-(void)updateTokenAmount;
-(void)callUserBackWithDelay:(int)delay;
-(void)hello;
@end

@interface AppDelegate
-(void)incrementTokens;
@end


%hook SBPowerDownController

-(void)orderFront {
    %log(@"called the orderFront method");
    NSLog(@"called the orderFront method");
    UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Device" message:@"Test Alert view" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [Alert show];
}

%end


%hook ViewController

 -(void)viewDidLoad {

    ((ViewController*)self).view.backgroundColor = [UIColor orangeColor];
    %log((NSString *)@"is the view loaded yet", (BOOL)[self isViewLoaded]);

    %log((NSString *)@"iOSRE", (int)123);
	%orig;
     
     //UIAlertView *Alert = [[UIAlertView alloc]initWithTitle:@"Device" message:@"Test Alert view" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
     
     //[Alert show];
     [((ViewController*)self) callKillerClown:nil];
     /*
     for (int i = 0; i < 10; i++) {
        [((ViewController*)self) rewardUserToken];
        %log((NSString*)@"tokens add = ", (int)i);
     } 
     */

    ButtonClass *buttonClass = [[ButtonClass alloc]init];
    UIButton *greenButton = [buttonClass createButton];
    [greenButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [((ViewController*)self).view addSubview:greenButton];
    

 }

 %new
 - (void)buttonAction {
    NSLog(@"button action called");
    [((ViewController*)self) rewardUserToken];
    [((ViewController*)self) updateTokenAmount];
    [((ViewController*)self) callUserBackWithDelay:2];
 }

/*
%new
-(void)callUserBackWithDelay:(int)delay {
    %log((NSString*)@"callUserBackWithDelay activated", (int)delay);
}
*/

 
%end

 //you can add commas to %init to init more classes

 

 %ctor {
	%init(
        ViewController = NSClassFromString(@"KillerClownCall.ViewController")
        //ViewController=objc_getClass("KillerClownCall.ViewController")
        
     );
 }




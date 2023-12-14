#import <Foundation/Foundation.h>
#import "APLRootListController.h"
// @import Preferences.PSSpecifier;
#import <Preferences/Preferences.h>
#import <objc/runtime.h>


@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

// @interface PSSwitchTableCell : UITableViewCell
// -(void)setValue:(id)arg1;
// -(void)setSelected:(BOOL)arg1 animated:(BOOL)arg2 ;
// -(id)controlValue;
// @end


static NSDictionary *myBundleDefaults;

static PSSpecifier *tweakEnabledSpecifier;
static PSSpecifier *biometricsSpecifier;
static PSSpecifier *passcodeSpecifier;


UITableView *myTableView;

NSMutableArray *_specefiers_copy;
NSMutableArray *cellArray;

@implementation APLRootListController

-(instancetype)init {
	self = [super init];
    if (self) {
        NSLog(@"init called successfully");
		[self createCustomSpecifiers];
		myBundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
    }
    return self;
}

-(id)customRead {
	NSLog(@"called customRead method");
	return @0;
}

void preferencesChanged() {
	NSLog(@"preferencesChanged called");

// 	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
//     NSNumber *isBiometricsEnabled = bundleDefaults[BIOMETRICS_SPECIFIER_KEY];

//     PSSwitchTableCell *biometricsSwitchCell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
// 	UISwitch *biometricsSwitchControl = (UISwitch*)biometricsSwitchCell.control;
   
//    if ([isBiometricsEnabled boolValue] == true) {
// 	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{BIOMETRICS_SPECIFIER_KEY:@0}
//                     forName:USER_DEFAULTS_DOMAIN];
// 	[biometricsSwitchControl setOn:true animated:true];

//    } else {
// 	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{BIOMETRICS_SPECIFIER_KEY:@1}
//                     forName:USER_DEFAULTS_DOMAIN];
// 	[biometricsSwitchControl setOn:false animated:true];
//    }

	// NSLog(@"the tableView: %@", myTableView);
	
	// NSLog(@"the PSSwitchCell: %@", switchCell);
	// NSLog(@"the control value: %@", [switchCell controlValue]);
}


-(void)createCustomSpecifiers {
	tweakEnabledSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
									target:self
									set:@selector(setPreferenceValue:specifier:)
									get:@selector(readPreferenceValue:)
									detail:Nil
									cell:PSSwitchCell
									edit:Nil];
	[tweakEnabledSpecifier setProperty:USER_DEFAULTS_DOMAIN forKey:@"defaults"];
	[tweakEnabledSpecifier setProperty:TWEAK_SPECIFIER_KEY forKey:@"key"];
	[biometricsSpecifier setProperty:@YES forKey:@"default"];
	[tweakEnabledSpecifier setProperty:@"tweakEnabledSpecifier" forKey:@"PostNotification"];


	biometricsSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Biometrics"
									target:self
									set:@selector(setPreferenceValue:specifier:)
									get:@selector(readPreferenceValue:)
									detail:Nil
									cell:PSSwitchCell
									edit:Nil];
	[biometricsSpecifier setProperty:USER_DEFAULTS_DOMAIN forKey:@"defaults"];
	[biometricsSpecifier setProperty:BIOMETRICS_SPECIFIER_KEY forKey:@"key"];
	[biometricsSpecifier setProperty:@YES forKey:@"default"];

	passcodeSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Passcode"
									target:self
									set:@selector(setPreferenceValue:specifier:)
									get:@selector(readPreferenceValue:)
									detail:Nil
									cell:PSSwitchCell
									edit:Nil];
	[passcodeSpecifier setProperty:USER_DEFAULTS_DOMAIN forKey:@"defaults"];
	[passcodeSpecifier setProperty:PASSCODE_SPECIFIER_KEY forKey:@"key"];
	[passcodeSpecifier setProperty:@NO forKey:@"default"];
	

}

-(void)ifAbsentInsertSpecifier:(PSSpecifier*)specifier atIndex:(int)index {
	NSUInteger containsSpecifier = [_specifiers indexOfObjectIdenticalTo:specifier];
	if (containsSpecifier == NSNotFound) {
		[_specifiers insertObject:specifier atIndex:index]; 
	}
}

- (NSMutableArray *)specifiers {
	
	_specifiers = [super specifiers]; //call super method to add all app specefiers via altlist

	// NSLog(@"_specifiers array before: %@", _specifiers);
	
	[self ifAbsentInsertSpecifier:tweakEnabledSpecifier atIndex:0];
	[self ifAbsentInsertSpecifier:biometricsSpecifier atIndex:1];
	[self ifAbsentInsertSpecifier:passcodeSpecifier atIndex:2];
	// NSLog(@"_specifiers array after: %@", _specifiers);
	
	// NSLog(@"specefiers method called: %p, is in _specefiers array: %lu", &tweakEnabledSpecifier, containsTweakEnabledSpecifier);
	return _specifiers;
}

-(void)viewDidLoad {
	cellArray = [NSMutableArray new];
	// [self createCustomSpecifiers];	
	NSLog(@"hello for viewDidLoad");
	NSLog(@"the cellType: %ld", biometricsSpecifier.cellType);
	
	// CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), 
	// 								NULL, 
	// 								(CFNotificationCallback)preferencesChanged, 
	// 								CFSTR("tweakEnabledSpecifier"), 
	// 								NULL, 
	// 								CFNotificationSuspensionBehaviorDeliverImmediately);

	//run the original viewDidLoad			
	[super viewDidLoad];	

	myTableView = [self table];

	NSLog(@"the tableView: %@", myTableView);
	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);

}


//MARK: helper methods

-(void)presentPasswordViewController {
	PasswordViewController *passwordVC = [[PasswordViewController alloc] init];


	[self presentViewController:passwordVC animated:true completion:nil];
}

-(void)setupSwitchSettings {
	//this runs after the PSListController settings and overrides it. I'm not sure what function is being used
	//to save the settings of enabled,biometrics, passcode switches

	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);

	// BOOL isTweakEnabled = bundleDefaults[TWEAK_SPECIFIER_KEY];
	// BOOL isBiometricsEnabled = bundleDefaults[BIOMETRICS_SPECIFIER_KEY];
	// BOOL isPasscodeEnabled = bundleDefaults[PASSCODE_SPECIFIER_KEY];


}

-(void)isEnabledSwitchChanged:(id)sender {
	NSLog(@"isEnabledSwitchChanged action called");

	UISwitch *isEnabledSwitch = (UISwitch*)sender;

    PSSwitchTableCell *biometricsSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:BIOMETRIC_CELL_INDEXPATH];
	UISwitch *biometricsSwitchControl = (UISwitch*)[biometricsSwitchCell control];

	PSSwitchTableCell *passcodeSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:PASSCODE_CELL_INDEXPATH];
	UISwitch *passcodeSwitchControl = (UISwitch*)[passcodeSwitchCell control];

   if (isEnabledSwitch.on == true) {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{TWEAK_SPECIFIER_KEY:@1,
																BIOMETRICS_SPECIFIER_KEY:@1, 
																PASSCODE_SPECIFIER_KEY:@0}
													forName:USER_DEFAULTS_DOMAIN];
	[biometricsSwitchControl setOn:true animated:true]; //set biometrics on by default
	[passcodeSwitchControl setOn:false animated:true];
   } else {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{TWEAK_SPECIFIER_KEY:@0,
																BIOMETRICS_SPECIFIER_KEY:@0, 
																PASSCODE_SPECIFIER_KEY:@0}
													forName:USER_DEFAULTS_DOMAIN];
	[passcodeSwitchControl setOn:false animated:true];
	[biometricsSwitchControl setOn:false animated:true];
   }

	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);
	
}

-(void)biometricsSwitchChanged:(id)sender {
	NSLog(@"biometricsSwitchChanged action called");
	UISwitch *biomentricsSwitch = (UISwitch*)sender;

    PSSwitchTableCell *passcodeSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:PASSCODE_CELL_INDEXPATH];
	UISwitch *passcodeSwitchControl = (UISwitch*)[passcodeSwitchCell control];
   
   if (biomentricsSwitch.on == true) {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{TWEAK_SPECIFIER_KEY:@1,
																BIOMETRICS_SPECIFIER_KEY:@1, 
																PASSCODE_SPECIFIER_KEY:@0}
                   							 forName:USER_DEFAULTS_DOMAIN];
	[passcodeSwitchControl setOn:false animated:true];

   } else {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{TWEAK_SPECIFIER_KEY:@1, 
																BIOMETRICS_SPECIFIER_KEY:@0, 
																PASSCODE_SPECIFIER_KEY:@1}
                    						forName:USER_DEFAULTS_DOMAIN];
	[passcodeSwitchControl setOn:true animated:true];
   }

	//turn on isEnabled cell too 
	PSSwitchTableCell *isEnabledSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:IS_ENABLED_CELL_INDEXPATH];
	UISwitch *isEnabledSwitchControl = (UISwitch*)[isEnabledSwitchCell control];
	[isEnabledSwitchControl setOn:true animated:true];

	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);
}

-(void)passcodeSwitchChanged:(id)sender {
	NSLog(@"passcodeSwitchChanged action called");

	UISwitch *passcodeSwitch = (UISwitch*)sender;

    PSSwitchTableCell *biometricsSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:BIOMETRIC_CELL_INDEXPATH];
	UISwitch *biometricsSwitchControl = (UISwitch*)[biometricsSwitchCell control];
   
   if (passcodeSwitch.on == true) {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{TWEAK_SPECIFIER_KEY:@1,
																BIOMETRICS_SPECIFIER_KEY:@0, 
																PASSCODE_SPECIFIER_KEY:@1}
                   							 forName:USER_DEFAULTS_DOMAIN];
	[biometricsSwitchControl setOn:false animated:true];

	[self presentPasswordViewController];
   } else {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{TWEAK_SPECIFIER_KEY:@1, 
																BIOMETRICS_SPECIFIER_KEY:@1, 
																PASSCODE_SPECIFIER_KEY:@0}
                    						forName:USER_DEFAULTS_DOMAIN];
	[biometricsSwitchControl setOn:true animated:true];
   }

	//turn on isEnabled cell too 
	PSSwitchTableCell *isEnabledSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:IS_ENABLED_CELL_INDEXPATH];
	UISwitch *isEnabledSwitchControl = (UISwitch*)[isEnabledSwitchCell control];
	[isEnabledSwitchControl setOn:true animated:true];

	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);
}

-(void)openGithub {
	[[UIApplication sharedApplication] 
	openURL:[NSURL URLWithString:@"https://github.com/opa334/AltList"]
	options:@{}
	completionHandler:nil];
}


//MARK: tableView delegate

- (void)tableView:(UITableView *)tableView 
  willDisplayCell:(UITableViewCell *)cell 
forRowAtIndexPath:(NSIndexPath *)indexPath {

	if ([indexPath compare:IS_ENABLED_CELL_INDEXPATH] == NSOrderedSame) {
		PSSwitchTableCell *isEnabledSwitchCell = (PSSwitchTableCell*)cell;

		UISwitch *isEnabledSwitchControl = (UISwitch*)[isEnabledSwitchCell control];
		[isEnabledSwitchControl addTarget:self 
									action:@selector(isEnabledSwitchChanged:) 
							forControlEvents:UIControlEventValueChanged]; 

		// BOOL switchValue = myBundleDefaults[TWEAK_SPECIFIER_KEY];
		// [isEnabledSwitchControl setOn:switchValue animated:false];

	}

	if ([indexPath compare:BIOMETRIC_CELL_INDEXPATH] == NSOrderedSame) {
		PSSwitchTableCell *biometricsSwitchCell = (PSSwitchTableCell*)cell;

		UISwitch *biometricsSwitchControl = (UISwitch*)[biometricsSwitchCell control];
		[biometricsSwitchControl addTarget:self 
									action:@selector(biometricsSwitchChanged:) 
							forControlEvents:UIControlEventValueChanged]; 

		// BOOL switchValue = myBundleDefaults[BIOMETRICS_SPECIFIER_KEY];
		// [biometricsSwitchControl setOn:switchValue animated:false];
	}

	if ([indexPath compare:PASSCODE_CELL_INDEXPATH] == NSOrderedSame) {
		PSSwitchTableCell *passcodeSwitchCell = (PSSwitchTableCell*)cell;

		UISwitch *passcodeSwitchControl = (UISwitch*)[passcodeSwitchCell control];
		[passcodeSwitchControl addTarget:self 
									action:@selector(passcodeSwitchChanged:) 
							forControlEvents:UIControlEventValueChanged];

		// BOOL switchValue = myBundleDefaults[PASSCODE_SPECIFIER_KEY];
		// [passcodeSwitchControl setOn:switchValue animated:false]; 
	}

	
}

// -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

// 	PSSwitchTableCell *myCell = (PSSwitchTableCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
// 	UISwitch *switchControl = (UISwitch*)[myCell control];
// 	NSLog(@"the cell: %@ and indexPath: %@, the UISwitch value: %d", myCell, indexPath, switchControl.on);
	 
// 	return myCell;
// }

@end

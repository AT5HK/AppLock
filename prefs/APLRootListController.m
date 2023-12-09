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




static PSSpecifier *tweakEnabledSpecifier;
static PSSpecifier *biometricsSpecifier;
static PSSpecifier *passcodeSpecifier;
// static UISwitch *biometricsSwitchControl;
// static UISwitch *passcodeSwitchControl;

UITableView *myTableView;

NSMutableArray *_specefiers_copy;
NSMutableArray *cellArray;

@implementation APLRootListController

-(instancetype)init {
	self = [super init];
    if (self) {
        NSLog(@"init called successfully");
		[self createCustomSpecifiers];
    }
    return self;
}

-(id)customRead {
	NSLog(@"called customRead method");
	return @0;
}

void preferencesChanged() {
	NSLog(@"preferencesChanged called");

// 	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.prefs.isTweakOn"];
//     NSNumber *isBiometricsEnabled = bundleDefaults[@"isBiometricsEnabled"];

//     PSSwitchTableCell *biometricsSwitchCell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
// 	UISwitch *biometricsSwitchControl = (UISwitch*)biometricsSwitchCell.control;
   
//    if ([isBiometricsEnabled boolValue] == true) {
// 	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"isBiometricsEnabled":@0}
//                     forName:@"com.applock.prefs.isTweakOn"];
// 	[biometricsSwitchControl setOn:true animated:true];

//    } else {
// 	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"isBiometricsEnabled":@1}
//                     forName:@"com.applock.prefs.isTweakOn"];
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
	[tweakEnabledSpecifier setProperty:@"com.applock.prefs.isTweakOn" forKey:@"defaults"];
	[tweakEnabledSpecifier setProperty:@"isTweakEnabled" forKey:@"key"];
	[biometricsSpecifier setProperty:@YES forKey:@"default"];
	[tweakEnabledSpecifier setProperty:@"tweakEnabledSpecifier" forKey:@"PostNotification"];


	biometricsSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Biometrics"
									target:self
									set:@selector(setPreferenceValue:specifier:)
									get:@selector(readPreferenceValue:)
									detail:Nil
									cell:PSSwitchCell
									edit:Nil];
	[biometricsSpecifier setProperty:@"com.applock.prefs.isTweakOn" forKey:@"defaults"];
	[biometricsSpecifier setProperty:@"isBiometricsEnabled" forKey:@"key"];
	[biometricsSpecifier setProperty:@YES forKey:@"default"];

	passcodeSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Passcode"
									target:self
									set:@selector(setPreferenceValue:specifier:)
									get:@selector(readPreferenceValue:)
									detail:Nil
									cell:PSSwitchCell
									edit:Nil];
	[passcodeSpecifier setProperty:@"com.applock.prefs.isTweakOn" forKey:@"defaults"];
	[passcodeSpecifier setProperty:@"isPasscodeEnabled" forKey:@"key"];
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
	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.prefs.isTweakOn"];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);

}


//MARK: helper methods

-(void)isEnabledSwitchChanged:(id)sender {
	NSLog(@"isEnabledSwitchChanged action called");

	UISwitch *isEnabledSwitch = (UISwitch*)sender;

    PSSwitchTableCell *biometricsSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:BIOMETRIC_CELL_INDEXPATH];
	UISwitch *biometricsSwitchControl = (UISwitch*)[biometricsSwitchCell control];

	PSSwitchTableCell *passcodeSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:PASSCODE_CELL_INDEXPATH];
	UISwitch *passcodeSwitchControl = (UISwitch*)[passcodeSwitchCell control];

   if (isEnabledSwitch.on == true) {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"isTweakEnabled":@1,
																@"isBiometricsEnabled":@1, 
																@"isPasscodeEnabled":@0}
													forName:@"com.applock.prefs.isTweakOn"];
	[biometricsSwitchControl setOn:true animated:true]; //set biometrics on by default
	[passcodeSwitchControl setOn:false animated:true];
   } else {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"isTweakEnabled":@0,
																@"isBiometricsEnabled":@0, 
																@"isPasscodeEnabled":@0}
													forName:@"com.applock.prefs.isTweakOn"];
	[passcodeSwitchControl setOn:false animated:true];
	[biometricsSwitchControl setOn:false animated:true];
   }

	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.prefs.isTweakOn"];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);
	
}

-(void)biometricsSwitchChanged:(id)sender {
	NSLog(@"biometricsSwitchChanged action called");
	UISwitch *biomentricsSwitch = (UISwitch*)sender;

    PSSwitchTableCell *passcodeSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:PASSCODE_CELL_INDEXPATH];
	UISwitch *passcodeSwitchControl = (UISwitch*)[passcodeSwitchCell control];
   
   if (biomentricsSwitch.on == true) {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"isTweakEnabled":@1,
																@"isBiometricsEnabled":@1, 
																@"isPasscodeEnabled":@0}
                   							 forName:@"com.applock.prefs.isTweakOn"];
	[passcodeSwitchControl setOn:false animated:true];

   } else {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"isTweakEnabled":@1, 
																@"isBiometricsEnabled":@0, 
																@"isPasscodeEnabled":@1}
                    						forName:@"com.applock.prefs.isTweakOn"];
	[passcodeSwitchControl setOn:true animated:true];
   }

	//turn on isEnabled cell too 
	PSSwitchTableCell *isEnabledSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:IS_ENABLED_CELL_INDEXPATH];
	UISwitch *isEnabledSwitchControl = (UISwitch*)[isEnabledSwitchCell control];
	[isEnabledSwitchControl setOn:true animated:true];

	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.prefs.isTweakOn"];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);
}

-(void)passcodeSwitchChanged:(id)sender {
	NSLog(@"passcodeSwitchChanged action called");

	UISwitch *passcodeSwitch = (UISwitch*)sender;

    PSSwitchTableCell *biometricsSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:BIOMETRIC_CELL_INDEXPATH];
	UISwitch *biometricsSwitchControl = (UISwitch*)[biometricsSwitchCell control];
   
   if (passcodeSwitch.on == true) {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"isTweakEnabled":@1,
																@"isBiometricsEnabled":@0, 
																@"isPasscodeEnabled":@1}
                   							 forName:@"com.applock.prefs.isTweakOn"];
	[biometricsSwitchControl setOn:false animated:true];

   } else {
	[[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"isTweakEnabled":@1, 
																@"isBiometricsEnabled":@1, 
																@"isPasscodeEnabled":@0}
                    						forName:@"com.applock.prefs.isTweakOn"];
	[biometricsSwitchControl setOn:true animated:true];
   }

	//turn on isEnabled cell too 
	PSSwitchTableCell *isEnabledSwitchCell = (PSSwitchTableCell*)[myTableView cellForRowAtIndexPath:IS_ENABLED_CELL_INDEXPATH];
	UISwitch *isEnabledSwitchControl = (UISwitch*)[isEnabledSwitchCell control];
	[isEnabledSwitchControl setOn:true animated:true];

	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.prefs.isTweakOn"];
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
	}

	if ([indexPath compare:BIOMETRIC_CELL_INDEXPATH] == NSOrderedSame) {
		PSSwitchTableCell *biometricsSwitchCell = (PSSwitchTableCell*)cell;

		UISwitch *biometricsSwitchControl = (UISwitch*)[biometricsSwitchCell control];
		[biometricsSwitchControl addTarget:self 
									action:@selector(biometricsSwitchChanged:) 
							forControlEvents:UIControlEventValueChanged]; 
	}

	if ([indexPath compare:PASSCODE_CELL_INDEXPATH] == NSOrderedSame) {
		PSSwitchTableCell *passcodeSwitchCell = (PSSwitchTableCell*)cell;

		UISwitch *passcodeSwitchControl = (UISwitch*)[passcodeSwitchCell control];
		[passcodeSwitchControl addTarget:self 
									action:@selector(passcodeSwitchChanged:) 
							forControlEvents:UIControlEventValueChanged]; 
	}

	
}

// -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
// 	// if (indexPath.row >= 3) {
// 	// 	return nil;
// 	// }
// 	UITableViewCell *myCell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
// 	[cellArray addObject: myCell];
// 	NSLog(@"the indexPath: %@", indexPath);
// 	return myCell;
// }

@end

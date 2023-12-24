#import <Foundation/Foundation.h>
#import "APLRootListController.h"
#import <Preferences/Preferences.h>

static PSSpecifier *tweakEnabledSpecifier;
static PSSpecifier *biometricsSpecifier;
static PSSpecifier *passcodeSpecifier;

UISwitch *isEnabledSwitchControl;
UISwitch *biometricsSwitchControl;
UISwitch *passcodeSwitchControl;

UITableView *myTableView;

@implementation APLRootListController

-(instancetype)init {
	self = [super init];
    if (self) {
        NSLog(@"init called successfully");
		[self createCustomSpecifiers];
    }
    return self;
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
	NSLog(@"hello for viewDidLoad");
	NSLog(@"the cellType: %ld", biometricsSpecifier.cellType);

	//run the original viewDidLoad			
	[super viewDidLoad];	

	myTableView = [self table];

	NSLog(@"the tableView: %@", myTableView);
	NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:USER_DEFAULTS_DOMAIN];
	NSLog(@"current bundleDefaults: %@", bundleDefaults);

}

//MARK: UIAdaptivePresentationControllerDelegate methods

- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController {
    NSLog(@"presentation controller dismissed by user");
	[self userDismissedPasscodeVC];
}


//MARK: helper methods

-(void)userDismissedPasscodeVC {
	//the user slid down modal view, the password is not saved so switch of passcode
	[passcodeSwitchControl setOn:false animated:true];
	[self passcodeSwitchChanged:nil];
}

-(void)presentPasswordViewController {
	PasswordViewController *passwordVC = [[PasswordViewController alloc] init];
	passwordVC.presentationController.delegate = self;
	[self presentViewController:passwordVC animated:true completion:nil];
}

//not in use rn
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
	//when switching biometrics off and passcode on present PasswordViewController
	[self presentPasswordViewController];
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


//MARK: tableView delegate

- (void)tableView:(UITableView *)tableView 
  willDisplayCell:(UITableViewCell *)cell 
forRowAtIndexPath:(NSIndexPath *)indexPath {

	if ([indexPath compare:IS_ENABLED_CELL_INDEXPATH] == NSOrderedSame) {
		PSSwitchTableCell *isEnabledSwitchCell = (PSSwitchTableCell*)cell;

		isEnabledSwitchControl = (UISwitch*)[isEnabledSwitchCell control];
		[isEnabledSwitchControl addTarget:self 
									action:@selector(isEnabledSwitchChanged:) 
							forControlEvents:UIControlEventValueChanged]; 


	}

	if ([indexPath compare:BIOMETRIC_CELL_INDEXPATH] == NSOrderedSame) {
		PSSwitchTableCell *biometricsSwitchCell = (PSSwitchTableCell*)cell;

		biometricsSwitchControl = (UISwitch*)[biometricsSwitchCell control];
		[biometricsSwitchControl addTarget:self 
									action:@selector(biometricsSwitchChanged:) 
							forControlEvents:UIControlEventValueChanged]; 

	}

	if ([indexPath compare:PASSCODE_CELL_INDEXPATH] == NSOrderedSame) {
		PSSwitchTableCell *passcodeSwitchCell = (PSSwitchTableCell*)cell;

		passcodeSwitchControl = (UISwitch*)[passcodeSwitchCell control];
		[passcodeSwitchControl addTarget:self 
									action:@selector(passcodeSwitchChanged:) 
							forControlEvents:UIControlEventValueChanged];

	}

	
}

@end

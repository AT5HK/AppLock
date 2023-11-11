#import <Foundation/Foundation.h>
#import "APLRootListController.h"
// @import Preferences.PSSpecifier;
#import <Preferences/Preferences.h>

static PSSpecifier* tweakEnabledSpecifier;


@implementation APLRootListController



- (NSMutableArray *)specifiers {
	
	_specifiers = [super specifiers]; //call super method to add all app specefiers via altlist

	NSLog(@"_specifiers array before: %@", _specifiers);
	NSUInteger containsTweakEnabledSpecifier = [_specifiers indexOfObjectIdenticalTo:tweakEnabledSpecifier];
	if (containsTweakEnabledSpecifier == NSNotFound) {
		[_specifiers insertObject:tweakEnabledSpecifier atIndex:0]; 
	}

	NSLog(@"_specifiers array after: %@", _specifiers);
	
	// NSLog(@"specefiers method called: %p, is in _specefiers array: %lu", &tweakEnabledSpecifier, containsTweakEnabledSpecifier);
	return _specifiers;
}

-(void)viewDidLoad {
	tweakEnabledSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Enabled"
									target:self
									set:@selector(setPreferenceValue:specifier:)
									get:@selector(readPreferenceValue:)
									detail:Nil
									cell:PSSwitchCell
									edit:Nil];
	[tweakEnabledSpecifier setProperty:@NO forKey:@"enabled"];
	[tweakEnabledSpecifier setProperty:@"com.applock.prefs.isTweakOn" forKey:@"defaults"];
	[tweakEnabledSpecifier setProperty:@"isTweakEnabled" forKey:@"key"];
	// [tweakEnabledSpecifier setProperty:@"tweakEnabledSpecifier" forKey:@"PostNotification"];
	[super viewDidLoad];
	
}


//MARK: helper methods
-(void)openGithub {
	[[UIApplication sharedApplication] 
	openURL:[NSURL URLWithString:@"https://github.com/opa334/AltList"]
	options:@{}
	completionHandler:nil];
}

@end

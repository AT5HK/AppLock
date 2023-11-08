#import <Foundation/Foundation.h>
#import "APLRootListController.h"
// @import Preferences.PSSpecifier;
#import <Preferences/Preferences.h>




@implementation APLRootListController



// - (NSArray *)specifiers {
// 	if (!_specifiers) {
// 		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
// 	}
// 	// for (int i = 0; i < _specifiers.count -1; i++) {
// 	// 	NSLog(@"cell preferences: %@", [self readPreferenceValue:_specifiers[i]]);
// 	// }
// 	PSSpecifier* testSpecifier = [PSSpecifier preferenceSpecifierNamed:@"test"
// 									    target:self
// 									       set:NULL
// 									       get:NULL
// 									    detail:Nil
// 									      cell:PSSwitchCell
// 									      edit:Nil];
// 	// testSpecifier.value = true;
// 	testSpecifier.name = @"generated specifier cell";
// 	[testSpecifier setProperty:@YES forKey:@"enabled"];
// 	[testSpecifier setProperty:@"0" forKey:@"default"];
// 	[_specifiers addObject: testSpecifier];
// 	return _specifiers;
// }


//MARK: helper methods
-(void)openGithub {
	[[UIApplication sharedApplication] 
	openURL:[NSURL URLWithString:@"https://github.com/opa334/AltList"]
	options:@{}
	completionHandler:nil];
}

@end

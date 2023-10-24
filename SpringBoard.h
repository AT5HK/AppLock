#import <Foundation/Foundation.h>
#import "RunningBoard.h"

@interface FBSystemService : NSObject
+ (id)sharedInstance;
- (void)exitAndRelaunch:(BOOL)arg1;
@end

@interface FBProcessExecutionContext : NSObject
@property (nonatomic,copy) NSDictionary *environment;
@property (nonatomic,copy) RBSProcessIdentity *identity;
@end

@interface FBProcessManager : NSObject
- (void)choicy_handleEnvironmentChangesForExecutionContext:(FBProcessExecutionContext *)executionContext forAppWithBundleIdentifier:(NSString *)bundleIdentifier;
@end

@interface SBApplicationInfo : NSObject
@property (nonatomic,readonly) NSURL *executableURL;
@property (nonatomic,readonly) BOOL hasHiddenTag;
@property (nonatomic,retain,readonly) NSArray *tags;
@end

@interface SBApplication : NSObject
- (SBApplicationInfo *)_appInfo;
@property (nonatomic,readonly) NSString * bundleIdentifier;

@end

@interface SBSApplicationShortcutIcon : NSObject
@end

@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
- (id)initWithImageData:(id)arg1 dataType:(long long)arg2 isTemplate:(bool)arg3;
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *localizedTitle;
@property (nonatomic,copy) NSString *localizedSubtitle;
@property (nonatomic,copy) SBSApplicationShortcutIcon *icon;
@property (nonatomic,copy) NSDictionary *userInfo; 
@property (assign,nonatomic) NSUInteger activationMode;
@property (nonatomic,copy) NSString *bundleIdentifierToLaunch;
@end

@interface SBIconView : NSObject
- (NSString *)applicationBundleIdentifier;
- (NSString *)applicationBundleIdentifierForShortcuts;
@end

@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
- (NSString *)applicationBundleIdentifier;
@end
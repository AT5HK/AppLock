#import <UIKit/UIKit.h>

@interface UIAlertController (Fast)
-(void)showAlertControllerWithVC:(UIViewController *)VC withMessage:(NSString *)message withTitle:(NSString *)title;
+(void)showAlertControllerWithVC:(UIViewController *)VC withMessage:(NSString *)message withTitle:(NSString *)title;
@end
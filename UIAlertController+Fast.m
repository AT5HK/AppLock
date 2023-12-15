#import "UIAlertController+Fast.h"

@implementation UIAlertController (Fast)

-(void)showAlertControllerWithVC:(UIViewController *)VC withMessage:(NSString *)message withTitle:(NSString *)title {
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
      handler:^(UIAlertAction * action) 
      {
        
      }];
   
   

   [alert addAction:defaultAction];
   [VC presentViewController:alert animated:YES completion:nil];
}

+(void)showAlertControllerWithVC:(UIViewController *)VC withMessage:(NSString *)message withTitle:(NSString *)title {
   UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
   
   UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
      handler:^(UIAlertAction * action) 
      {
        
      }];
   
   

   [alert addAction:defaultAction];
   [VC presentViewController:alert animated:YES completion:nil];
}

@end
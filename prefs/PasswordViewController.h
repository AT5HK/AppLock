#import <UIKit/UIKit.h>
#import "Common.h"

@interface PasswordViewController: UIViewController <UITextFieldDelegate>
@property(nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UITextField *retypePasswordTextField;
@property(nonatomic, strong) UIButton *setPasswordButton;

@property (weak, nonatomic) NSLayoutConstraint *constraintCenterVerticallyToSuperView;
@end
#import <UIKit/UIKit.h>
#import "UIAlertController+Fast.h"
#import "Common.h"

@interface PasswordViewController: UIViewController <UITextFieldDelegate, UIAdaptivePresentationControllerDelegate>
@property(nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UITextField *retypePasswordTextField;
@property(nonatomic, strong) UIButton *setPasswordButton;

@property (weak, nonatomic) NSLayoutConstraint *constraintCenterVerticallyToSuperView;
@end
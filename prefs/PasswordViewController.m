#import "PasswordViewController.h"

@implementation PasswordViewController 

-(void)loadView {
    NSLog(@"PasswordViewController load view called");
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.view.backgroundColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:232.0/255.0 alpha:1];
    
    [self setupTextFields];
    [self setupButton];
    [self setupKeyboardObservers];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"PasswordViewController viewDidLoad called");
    // self.passwordTextField = [self createPasswordTextField];
    // [self.view addSubview:self.passwordTextField];
    
}

- (void)dealloc {
    // Unregister for keyboard notifications in dealloc
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began called");
    [self.passwordTextField resignFirstResponder];
    [self.retypePasswordTextField resignFirstResponder];
}

//MARK: helper methods

-(void)setupTextFields {
    self.passwordTextField = [self createPasswordTextFieldWithPlaceHolderText:@"Password"];
    self.retypePasswordTextField = [self createPasswordTextFieldWithPlaceHolderText:@"Retype Password"];
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = false;
    self.retypePasswordTextField.translatesAutoresizingMaskIntoConstraints = false;
    self.passwordTextField.delegate = self;
    self.retypePasswordTextField.delegate = self;

    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.retypePasswordTextField];

    [self constraintCenterHorizontallyWithView:self.retypePasswordTextField toView:self.view];
    [self constraintCenterHorizontallyWithView:self.passwordTextField toView:self.view];


    [self constraintWidthOfView:self.retypePasswordTextField withView:self.view withMultiplier:0.75];
    // [self constraintHeightOfView:self.retypePasswordTextField withView:self.view withMultiplier:0.1];

    // [self constraintWidthOfView:self.retypePasswordTextField withConstant:50];
    [self constraintHeightOfView:self.retypePasswordTextField withConstant:50];

    [self constraintWidthOfView:self.passwordTextField withView:self.view withMultiplier:0.75];
    // [self constraintHeightOfView:self.passwordTextField withView:self.view withMultiplier:0.05];

    // [self constraintWidthOfView:self.passwordTextField withConstant:50];
    [self constraintHeightOfView:self.passwordTextField withConstant:50];

    [self constraintBottomOfView:self.retypePasswordTextField toTopOfView:self.passwordTextField];
}

-(void)setupButton {
    self.setPasswordButton = [self createButton];
    self.setPasswordButton.translatesAutoresizingMaskIntoConstraints = false;

    [self.view addSubview:self.setPasswordButton];

    [self constraintCenterHorizontallyWithView:self.setPasswordButton toView:self.view];
    [self constraintCenterVerticallyWithView:self.setPasswordButton toView:self.view];
    [self constraintBottomOfView:self.setPasswordButton toTopOfView:self.retypePasswordTextField];

    [self constraintWidthOfView:self.setPasswordButton withView:self.view withMultiplier:0.75];
    // [self constraintHeightOfView:self.setPasswordButton withView:self.view withMultiplier:0.08];

    // [self constraintWidthOfView:self.setPasswordButton withConstant:50];
    [self constraintHeightOfView:self.setPasswordButton withConstant:50];
}

-(UITextField *)createPasswordTextFieldWithPlaceHolderText:(NSString*)text  {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 34)];
    textField.backgroundColor = UIColor.whiteColor;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = text;
    textField.secureTextEntry = true;
    return textField;
}

-(UIButton *)createButton {
    UIButton *passwordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    passwordButton.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [passwordButton addTarget:self action:@selector(setPasswordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [passwordButton setTitle:@"Confirm" forState:UIControlStateNormal];
    passwordButton.frame = CGRectMake(0, 0, 100, 30);
    passwordButton.layer.cornerRadius = 8.0;
    passwordButton.layer.masksToBounds = true;
    return passwordButton;
}

//MARK: button action

-(void)setPasswordButtonAction:(id)sender {
    NSLog(@"setPasswordButtonAction called");
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:@{@"passcode":self.passwordTextField.text}
													forName:@"com.applock.passcode"];

    NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.applock.passcode"];
	NSLog(@"passcode in bundleDefaults: %@", bundleDefaults);
}

//MARK: Keyboard methods

-(void)setupKeyboardObservers {
    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {

    // Animate the view position change
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.constraintCenterVerticallyToSuperView.constant = -50;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // Reset the view frame to the original position
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.constraintCenterVerticallyToSuperView.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

//MARK: Text field delegate

// Implementing UITextFieldDelegate method to dismiss keyboard on return key press
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//MARK: constraints

-(void)constraintBottomOfView:(UIView *)view1 toTopOfView:(UIView *)view2 {
    NSLayoutConstraint *constraintBottomVertically = [NSLayoutConstraint
                                          constraintWithItem:view1
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:view2
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1.0
                                          constant:20];
    
    [self.view addConstraint:constraintBottomVertically];
}

-(void)constraintWidthOfView:(UIView *)view1 withView:(UIView *)view2 withMultiplier:(double)multiplier {
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view1
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:view2
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:multiplier
                                                                        constant:0];
    [view1.superview addConstraint:widthConstraint];
}

-(void)constraintHeightOfView:(UIView *)view1 withView:(UIView *)view2 withMultiplier:(double)multiplier{
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view1
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:view2
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:multiplier
                                                                        constant:0];
    [view1.superview addConstraint:heightConstraint];
}

//experimental

-(void)constraintWidthOfView:(UIView *)view1 withConstant:(int)width {
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view1
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:width];
    [view1 addConstraint:widthConstraint];
}

-(void)constraintHeightOfView:(UIView *)view1 withConstant:(int)height {
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view1
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:height];
    [view1 addConstraint:heightConstraint];
}

//experimental ^^^^

-(void)constraintCenterHorizontallyWithView:(UIView *)firstView toView:(UIView *)secondView {
    NSLayoutConstraint *centreHorizontallyConstraint = [NSLayoutConstraint
                                      constraintWithItem:firstView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:secondView
                                      attribute:NSLayoutAttributeCenterX
                                      multiplier:1.0
                                      constant:0];

[secondView addConstraint:centreHorizontallyConstraint];

}

-(void)constraintCenterVerticallyWithView:(UIView *)firstView toView:(UIView *)secondView {
    self.constraintCenterVerticallyToSuperView = [NSLayoutConstraint
                                      constraintWithItem:firstView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:secondView
                                      attribute:NSLayoutAttributeCenterY
                                      multiplier:1.0
                                      constant:0];

[secondView addConstraint:self.constraintCenterVerticallyToSuperView];
}

@end